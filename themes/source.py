"""Resolve a pinned, cached Xcode Pitch source or an explicitly selected checkout."""

import importlib.util
import io
import json
import os
from pathlib import Path, PurePosixPath
import re
import tarfile
import tempfile
import urllib.request

LOCK = Path(__file__).with_name("source.lock.json")
CACHE = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "dotfiles-theme" / "sources"
REQUIRED = ("package.json", "LICENSE", "palettes/dark.json", "palettes/light.json", "scripts/build_themes.py",
            "scripts/build_light.py", "templates/vscode/dark.jsonc", "templates/vscode/bordered.jsonc",
            "extras/ghostty/xcode-dark", "extras/ghostty/xcode-light",
            "extras/opencode/xcode-pitch.json", "extras/herdr/auto.toml", "extras/herdr/dark.toml",
            "extras/herdr/light.toml", "extras/neovim/lua/xcode_pitch/init.lua",
            "extras/neovim/lua/xcode_pitch/palettes.lua", "extras/neovim/colors/xcode_pitch.lua")


def validate(root):
    root = root.expanduser().resolve()
    for relative in REQUIRED:
        if not (root / relative).is_file():
            raise ValueError(f"Incomplete Xcode Pitch source: {root / relative}")
    manifest = json.loads((root / "package.json").read_text())
    if (manifest.get("publisher"), manifest.get("name")) != ("albertochamorro", "xcode-pitch-dark-theme"):
        raise ValueError(f"Unexpected extension identity in {root}")
    return root


def extract_archive(data, destination):
    """Extract regular source files only; never follow tar links or unsafe paths."""
    allowed = {"package.json", "LICENSE", "scripts", "palettes", "templates", "themes", "extras"}
    total = 0
    with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as archive:
        for member in archive:
            parts = PurePosixPath(member.name).parts
            if not parts or member.name.startswith("/") or ".." in parts or "\\" in member.name:
                raise ValueError("Unsafe path in theme archive")
            if member.isdir():
                continue
            if not member.isfile():
                raise ValueError("Links and special files are not allowed in theme archives")
            relative = parts[1:]
            if not relative or relative[0] not in allowed:
                continue
            total += member.size
            if total > 64 * 1024 * 1024:
                raise ValueError("Theme source archive is too large")
            path = destination.joinpath(*relative)
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(archive.extractfile(member).read())


def resolve(local=None):
    local = local or os.environ.get("XCODE_PITCH_SOURCE")
    if local:
        return validate(Path(local))
    lock = json.loads(LOCK.read_text())
    revision = lock["revision"]
    if lock.get("repository") != "achamorro-dev/xcode-pitch-theme" or not re.fullmatch(r"[0-9a-f]{40}", revision):
        raise ValueError(f"Invalid theme source lock: {LOCK}")
    target = CACHE / revision
    if target.exists():
        return validate(target)
    CACHE.mkdir(parents=True, exist_ok=True)
    url = f'https://codeload.github.com/{lock["repository"]}/tar.gz/{revision}'
    with urllib.request.urlopen(url, timeout=60) as response:
        data = response.read(20 * 1024 * 1024 + 1)
    if len(data) > 20 * 1024 * 1024:
        raise ValueError("Compressed theme archive is too large")
    with tempfile.TemporaryDirectory(dir=CACHE, prefix=".install-") as temporary:
        staging = Path(temporary) / "source"
        staging.mkdir()
        extract_archive(data, staging)
        validate(staging)
        try:
            staging.rename(target)
        except FileExistsError:
            pass
    return validate(target)


def generator(root):
    spec = importlib.util.spec_from_file_location("xcode_pitch_generator", root / "scripts" / "build_themes.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module
