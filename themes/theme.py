#!/usr/bin/env python3
"""Install upstream themes and synchronize personal application preferences."""

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

from jsonc import load_jsonc, update_jsonc
import source

ROOT = Path(__file__).resolve().parent.parent
HERE = ROOT / "themes"
GENERATED = HERE / "generated"
CONFIG = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
STATE = CONFIG / "dotfiles-theme" / "state.json"
EDITOR_THEMES = {"xcode-dark": "Xcode Pitch Dark Theme", "xcode-light": "Xcode Pitch Light", "ayu-light": "Ayu Light"}
PITCH_EXTENSION = "albertochamorro.xcode-pitch-dark-theme"
AYU_EXTENSION = "teabyii.ayu"
LEGACY_EXTENSION = "albertochamorro.dotfiles-pitch-themes"


def dump(value):
    return json.dumps(value, indent=2, ensure_ascii=False) + "\n"


def write(path, content, backup=False):
    """Atomic, idempotent writes, following symlinks instead of replacing them."""
    path = path.resolve()
    old = path.read_text() if path.exists() else None
    if old == content:
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    saved = path.with_name(path.name + ".before-dotfiles-theme")
    if backup and old is not None and not saved.exists():
        shutil.copy2(path, saved)
    fd, temp = tempfile.mkstemp(dir=path.parent, prefix=".theme-")
    try:
        with os.fdopen(fd, "w") as stream:
            stream.write(content)
        if path.exists():
            os.chmod(temp, path.stat().st_mode & 0o777)
        os.replace(temp, path)
    finally:
        if os.path.exists(temp):
            os.unlink(temp)
    return True


def build(pitch_source=None, output=None):
    """Consume upstream exports; only the external Ayu alternative is composed here."""
    output = output or GENERATED
    upstream = source.resolve(pitch_source)
    renderer = source.generator(upstream)
    renderer.build(check=True)
    palettes = renderer.palettes()
    ayu = json.loads((HERE / "ayu-light.json").read_text())
    for mode in ("dark", "light"):
        write(output / "ghostty" / f"xcode-{mode}", (upstream / "extras/ghostty" / f"xcode-{mode}").read_text())
    write(output / "ghostty" / "ayu-light", renderer.ghostty(ayu))
    write(output / "opencode" / "pitch-xcode-light.json", (upstream / "extras/opencode/xcode-pitch.json").read_text())
    write(output / "opencode" / "pitch-ayu-light.json", dump(renderer.opencode_theme(palettes["dark"], ayu)))
    for mode in ("auto", "dark", "light"):
        write(output / "herdr" / f"xcode-{mode}.toml", (upstream / "extras/herdr" / f"{mode}.toml").read_text())
        write(output / "herdr" / f"ayu-{mode}.toml", renderer.herdr_theme(palettes["dark"], ayu, mode))
    for path in (upstream / "extras/neovim").rglob("*.lua"):
        write(output / "neovim" / path.relative_to(upstream / "extras/neovim"), path.read_text())
    write(output / "neovim/LICENSE", (upstream / "LICENSE").read_text())
    write(output / "palettes.json", dump({"xcode-dark": palettes["dark"], "xcode-light": palettes["light"], "ayu-light": ayu}))
    lock = json.loads(source.LOCK.read_text()) if source.LOCK.exists() else None
    write(output / "source.json", dump({"path": str(upstream), "lock": lock, "local_override": bool(pitch_source or os.environ.get("XCODE_PITCH_SOURCE"))}))
    return output


def read_state():
    state = json.loads(STATE.read_text()) if STATE.exists() else {"mode": "auto", "light": "xcode-light"}
    if state.get("mode") not in ("auto", "dark", "light") or state.get("light") not in ("xcode-light", "ayu-light"):
        raise ValueError(f"Invalid theme state: {STATE}")
    return state


def system_mode():
    if sys.platform == "darwin":
        result = subprocess.run(["defaults", "read", "-g", "AppleInterfaceStyle"], capture_output=True, text=True, timeout=5)
        return "dark" if result.stdout.strip().lower() == "dark" else "light"
    return "dark"


def editor_settings(state):
    dark, light = EDITOR_THEMES["xcode-dark"], EDITOR_THEMES[state["light"]]
    mode = system_mode() if state["mode"] == "auto" else state["mode"]
    return {"window.autoDetectColorScheme": state["mode"] == "auto",
            "workbench.preferredDarkColorTheme": dark, "workbench.preferredLightColorTheme": light,
            "workbench.colorTheme": dark if mode == "dark" else light}


def herdr_theme(state):
    variant = "ayu" if state["light"] == "ayu-light" else "xcode"
    path = STATE.parent / "herdr" / f'{variant}-{state["mode"]}.toml'
    if not path.exists():
        raise ValueError("Theme assets are missing. Run theme install first.")
    return "[theme]" + path.read_text().split("[theme]", 1)[1]


def replace_herdr_theme(text, state):
    pattern = r"(?ms)^\[theme(?:\.[^\]\n]+)?\][^\n]*\n.*?(?=^\[|\Z)"
    first = True

    def replace(match):
        nonlocal first
        if first:
            first = False
            return herdr_theme(state)
        return ""

    result, count = re.subn(pattern, replace, text)
    return result if count else text.rstrip() + "\n\n" + herdr_theme(state)


def paths():
    support = Path.home() / "Library" / "Application Support"
    return {
        "ghostty": support / "com.mitchellh.ghostty" / "config" if sys.platform == "darwin" else CONFIG / "ghostty" / "config",
        "opencode": CONFIG / "opencode" / "cli.json",
        "herdr": CONFIG / "herdr" / "config.toml",
        "VSCode": support / "Code" / "User" / "settings.json" if sys.platform == "darwin" else CONFIG / "Code" / "User" / "settings.json",
        "Cursor": support / "Cursor" / "User" / "settings.json" if sys.platform == "darwin" else CONFIG / "Cursor" / "User" / "settings.json",
    }


def apply(state, reload=True):
    changes = []
    for app, path in paths().items():
        if not path.exists():
            print(f"Skip {app}: {path} does not exist", file=sys.stderr)
            continue
        old = path.read_text()
        if app == "ghostty":
            theme = f'dark:xcode-dark,light:{state["light"]}' if state["mode"] == "auto" else (
                "xcode-dark" if state["mode"] == "dark" else state["light"])
            new, count = re.subn(r"(?m)^theme\s*=.*$", "theme = " + theme, old)
            if not count:
                new = old.rstrip() + "\ntheme = " + theme + "\n"
        elif app == "opencode":
            config = load_jsonc(old)
            theme = dict(config.get("theme") or {})
            theme.update(name="pitch-" + state["light"], mode="system" if state["mode"] == "auto" else state["mode"])
            new = update_jsonc(old, {"theme": theme})
        elif app == "herdr":
            new = replace_herdr_theme(old, state)
        else:
            new = update_jsonc(old, editor_settings(state))
        changes.append((app, path, new))
    changed = [app for app, path, new in changes if write(path, new, backup=True)]
    write(STATE, dump(state))
    if reload:
        reload_apps(changed)
    return changed


def detach_herdr_template():
    """Migrate only our managed template symlink, retaining all local preferences."""
    path = paths()["herdr"]
    template = ROOT / "herdr/config/config.toml"
    if path.is_symlink() and path.resolve() == template.resolve():
        content = path.read_text()
        path.unlink()
        write(path, content)


def reload_apps(changed):
    if "ghostty" in changed and sys.platform == "darwin":
        script = '''if application "Ghostty" is running then
tell application "Ghostty"
if (count of terminals) > 0 then perform action "reload_config" on item 1 of terminals
end tell
end if'''
        run_reload(["osascript", "-e", script], "Ghostty: reload manually with Cmd+S, R if automation is denied")
    if "herdr" in changed and shutil.which("herdr"):
        run_reload(["herdr", "server", "reload-config"], "Herdr: use Alt+Shift+R if the client did not refresh")


def run_reload(command, warning):
    try:
        result = subprocess.run(command, capture_output=True, text=True, timeout=5)
        if result.returncode:
            print(warning, file=sys.stderr)
    except (OSError, subprocess.TimeoutExpired):
        print(warning, file=sys.stderr)


def installed_extensions(cli):
    result = subprocess.run([cli, "--list-extensions", "--show-versions"],
                            capture_output=True, text=True, check=True, timeout=30)
    return dict(line.strip().lower().rsplit("@", 1) for line in result.stdout.splitlines()
                if re.fullmatch(r"[^\s@]+@[^\s@]+", line.strip()))


def pitch_has_light(version):
    return bool(re.fullmatch(r"\d+\.\d+\.\d+", version)
                and tuple(map(int, version.split("."))) >= (1, 2, 0))


def install_editors(pitch_vsix=None):
    if pitch_vsix is not None and not pitch_vsix.is_file():
        raise ValueError(f"VSIX does not exist: {pitch_vsix}")
    for app, cli in {
        "VSCode": "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code",
        "Cursor": "/Applications/Cursor.app/Contents/Resources/app/bin/cursor",
    }.items():
        if not Path(cli).exists():
            print(f"Skip {app}: editor CLI not found", file=sys.stderr)
            continue
        extensions = installed_extensions(cli)
        if pitch_vsix is not None or not pitch_has_light(extensions.get(PITCH_EXTENSION, "")):
            selected = str(pitch_vsix) if pitch_vsix is not None else PITCH_EXTENSION
            subprocess.run([cli, "--install-extension", selected, "--force"], check=True, timeout=120)
            extensions = installed_extensions(cli)
        if not pitch_has_light(extensions.get(PITCH_EXTENSION, "")):
            raise ValueError(f"{app}: Xcode Pitch Theme 1.2.0+ is required. Until it is published, "
                             "run theme install --pitch-vsix /path/to/xcode-pitch-dark-theme-1.2.0.vsix")
        if AYU_EXTENSION not in extensions:
            subprocess.run([cli, "--install-extension", AYU_EXTENSION], check=True, timeout=120)
        if LEGACY_EXTENSION in extensions:
            subprocess.run([cli, "--uninstall-extension", LEGACY_EXTENSION], check=True, timeout=30)


def install(reload=True, pitch_vsix=None, pitch_source=None):
    output = build(pitch_source)
    install_editors(pitch_vsix)
    for app in ("ghostty", "opencode"):
        for asset in (output / app).iterdir():
            write(CONFIG / app / "themes" / asset.name, asset.read_text(), backup=True)
    for directory in ("herdr", "neovim"):
        for asset in (output / directory).rglob("*"):
            if asset.is_file():
                write(STATE.parent / directory / asset.relative_to(output / directory), asset.read_text())
    for name in ("palettes.json", "source.json"):
        write(STATE.parent / name, (output / name).read_text())
    detach_herdr_template()
    apply(read_state(), reload=reload)
    print("Installed upstream themes. Reload editors/OpenCode once if they have not discovered the new files.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", nargs="?", default="status",
                        choices=("auto", "dark", "light", "status", "build", "install"))
    parser.add_argument("--light", choices=("xcode", "ayu"), help="Light palette (also saved for auto mode)")
    parser.add_argument("--no-reload", action="store_true", help="Write configuration without contacting running apps")
    parser.add_argument("--pitch-vsix", type=Path, help="Install the official Xcode Pitch Theme from a local VSIX")
    parser.add_argument("--source", type=Path, help="Use a local Xcode Pitch checkout instead of the pinned download")
    args = parser.parse_args()
    if args.command == "build":
        print(build(args.source))
        return
    if args.command == "install":
        install(reload=not args.no_reload, pitch_vsix=args.pitch_vsix, pitch_source=args.source)
        return
    state = read_state()
    if args.command == "status":
        mode = system_mode() if state["mode"] == "auto" else state["mode"]
        print(f'{state["mode"]} ({mode}) · {state["light"]} · {STATE}')
        return
    if not (STATE.parent / "palettes.json").exists():
        raise ValueError("Run theme install first")
    state["mode"] = args.command
    if args.light:
        state["light"] = args.light + "-light"
    changed = apply(state, reload=not args.no_reload)
    print(f'{state["mode"]} · {state["light"]} · updated: {", ".join(changed) or "none"}')


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        sys.exit(f"theme: {error}")
