#!/usr/bin/env python3
"""Build and synchronize editor/terminal themes. Python 3.9+, standard library only."""

import argparse
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parent.parent
HERE = ROOT / "themes"
GENERATED = HERE / "generated"
CONFIG = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
STATE = CONFIG / "dotfiles-theme" / "state.json"
PALETTES = json.loads((HERE / "palettes.json").read_text())
PITCH_EXTENSION = "albertochamorro.xcode-pitch-dark-theme"
AYU_EXTENSION = "teabyii.ayu"
LEGACY_EXTENSION = "albertochamorro.dotfiles-pitch-themes"


def tokens(text):
    """JSONC lexer; never interpret comment markers inside strings as comments."""
    pattern = r'"(?:[^"\\]|\\.)*"|//[^\n]*|/\*[\s\S]*?\*/|\s+|[^\s]'
    return [(m.group(), m.start(), m.end()) for m in re.finditer(pattern, text)
            if not m.group().isspace() and not m.group().startswith(("//", "/*"))]


def load_jsonc(text):
    parts = tokens(text)
    return json.loads("".join(t[0] for i, t in enumerate(parts)
                              if not (t[0] == "," and i + 1 < len(parts)
                                      and parts[i + 1][0] in ("}", "]"))))


def update_jsonc(text, updates):
    """Replace only requested root properties, preserving other bytes and comments."""
    data = load_jsonc(text)
    if not isinstance(data, dict):
        raise ValueError("Expected a JSON object")
    for key, value in updates.items():
        if key in data and data[key] == value:
            continue
        ts = tokens(text)
        depth, spans = 0, []
        for i, (token, start, end) in enumerate(ts):
            if depth == 1 and token.startswith('"') and ts[i + 1][0] == ":":
                name = json.loads(token)
                j, nested = i + 2, 0
                while j < len(ts):
                    current = ts[j][0]
                    if nested == 0 and current in (",", "}"):
                        break
                    nested += current in ("{", "[")
                    nested -= current in ("}", "]")
                    j += 1
                if name == key:
                    spans.append((ts[i + 2][1], ts[j - 1][2]))
            depth += token in ("{", "[")
            depth -= token in ("}", "]")
        if len(spans) > 1:
            raise ValueError(f"Duplicate setting: {key}")
        encoded = json.dumps(value, ensure_ascii=False)
        indent_match = re.search(r'(?m)^([ \t]+)"', text)
        indent = indent_match.group(1) if indent_match else "  "
        if spans:
            start, end = spans[0]
            if "\n" in text[start:end]:
                line = text[text.rfind("\n", 0, start) + 1:start]
                leading = re.match(r"[ \t]*", line).group()
                encoded = json.dumps(value, ensure_ascii=False, indent=indent).replace("\n", "\n" + leading)
            text = text[:start] + encoded + text[end:]
        else:
            close = ts[-1][1]
            comma = "," if len(ts) > 2 and ts[-2][0] != "," else ""
            # Put a missing comma before trailing comments, not inside them.
            last = ts[-2][2] if len(ts) > 2 else ts[0][2]
            prefix = text[:last] + comma + text[last:close]
            text = (prefix + ("" if prefix.endswith("\n") else "\n")
                    + f'{indent}{json.dumps(key)}: {encoded}\n' + text[close:])
        data[key] = value
    load_jsonc(text)
    return text


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


def dump(value):
    return json.dumps(value, indent=2, ensure_ascii=False) + "\n"


def mix(a, b, weight):
    a, b = a.lstrip("#"), b.lstrip("#")
    return "#" + "".join(f"{round(int(a[i:i+2], 16) * (1-weight) + int(b[i:i+2], 16) * weight):02x}"
                         for i in (0, 2, 4))


def terminal_colors(p):
    return ["#242429" if p["mode"] == "dark" else "#26262b",
            *[p[k] for k in ("red", "green", "yellow", "blue", "purple", "cyan")],
            "#d0d0d8", p["muted"],
            *[p[k] for k in ("red", "green", "yellow", "blue", "purple", "cyan")],
            "#ffffff" if p["mode"] == "dark" else "#ededf0"]


def ghostty(p):
    fields = {"background": p["background"], "foreground": p["foreground"],
              "cursor-color": p["cursor"], "cursor-text": p["background"],
              "selection-background": p["selection"], "selection-foreground": p["foreground"]}
    return ("# Generated from themes/palettes.json\n"
            + "".join(f"{k} = {v}\n" for k, v in fields.items())
            + "".join(f"palette = {i}={v}\n" for i, v in enumerate(terminal_colors(p))))


def opencode_mode(p):
    """Complete V2 token tree (not the deprecated V1 theme/defs shape)."""
    bg, fg = p["background"], p["foreground"]
    feedback = {"error": p["red"], "warning": p["yellow"],
                "success": p["green"], "info": p["blue"]}
    hues = {}
    for hue, color in {"gray": fg, **{k: p[k] for k in
                          ("red", "orange", "yellow", "green", "cyan", "blue", "purple")}}.items():
        hues[hue] = {str(step): mix(color, bg, (step - 100) / 850)
                     for step in range(100, 1000, 100)}
    hues.update(accent="$hue.blue", interactive="$hue.blue", neutral="$hue.gray")
    hues["gray"].update({"200": fg, "400": p["muted"], "600": p["raised"],
                         "700": p["surface"], "800": bg, "900": bg})
    action_text = {k: {"base": fg, "$hovered": p["accent"], "$disabled": p["muted"]}
                   for k in ("primary", "secondary", "destructive")}
    action_text["destructive"]["base"] = p["red"]
    return {
        "hue": hues,
        "categorical": ["blue", "purple", "green", "cyan", "orange"],
        "text": {"base": fg, "muted": p["muted"], "action": action_text,
                 "formfield": {"base": fg, "$focused": p["accent"]},
                 "feedback": {k: {"base": v} for k, v in feedback.items()}},
        "background": {"base": bg, "raised": {"base": p["surface"], "high": p["raised"], "max": p["selection"]},
                       "action": {k: {"base": "transparent", "$hovered": p["raised"],
                                      "$selected": p["selection"]}
                                  for k in ("primary", "secondary", "destructive")},
                       "formfield": {"base": p["surface"]},
                       "feedback": {k: {"base": mix(bg, v, .10)} for k, v in feedback.items()}},
        "border": {"base": p["border"]}, "scrollbar": {"base": p["muted"]},
        "diff": {"text": {"added": p["green"], "removed": p["red"], "context": fg, "hunkHeader": p["purple"]},
                 "background": {"added": mix(bg, p["green"], .12), "removed": mix(bg, p["red"], .12), "context": bg},
                 "highlight": {"added": mix(bg, p["green"], .25), "removed": mix(bg, p["red"], .25)},
                 "lineNumber": {"text": p["muted"], "background": {"added": bg, "removed": bg}}},
        "syntax": {k: p[k] for k in ("comment", "keyword", "function", "variable", "string", "number", "type", "operator", "punctuation")},
        "markdown": {k: p[v] for k, v in {
            "text": "foreground", "heading": "accent", "link": "blue", "linkText": "cyan",
            "code": "string", "blockQuote": "comment", "emphasis": "purple", "strong": "foreground",
            "horizontalRule": "muted", "listItem": "keyword", "listEnumeration": "number",
            "image": "blue", "imageText": "cyan", "codeBlock": "foreground"}.items()},
        "@dialog": {"background": {"base": "$background.raised.base"}}
    }


def build():
    for key, p in PALETTES.items():
        write(GENERATED / "ghostty" / key, ghostty(p))
    dark_mode = opencode_mode(PALETTES["xcode-dark"])
    base = {k: v for k, v in dark_mode.items() if k != "hue"}
    for light in ("xcode-light", "ayu-light"):
        write(GENERATED / "opencode" / f"pitch-{light}.json", dump({
            "base": base, "dark": {"hue": dark_mode["hue"]}, "light": opencode_mode(PALETTES[light])}))


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
    dark, light = PALETTES["xcode-dark"]["name"], PALETTES[state["light"]]["name"]
    mode = system_mode() if state["mode"] == "auto" else state["mode"]
    return {"window.autoDetectColorScheme": state["mode"] == "auto",
            "workbench.preferredDarkColorTheme": dark, "workbench.preferredLightColorTheme": light,
            "workbench.colorTheme": dark if mode == "dark" else light}


def herdr_theme(state):
    auto = state["mode"] == "auto"
    text = '[theme]\nname = "terminal"\nauto_switch = ' + str(auto).lower() + '\n'
    if auto:
        text += 'dark_name = "terminal"\nlight_name = "terminal"\n'
    for mode in (("dark", "light") if auto else (state["mode"],)):
        p = PALETTES["xcode-dark" if mode == "dark" else state["light"]]
        text += "\n[theme.custom" + (f".{mode}" if auto else "") + "]\n"
        fields = {"panel_bg": "background", "sidebar_bg": "background", "text": "foreground",
                  "accent": "accent", "active_row_bg": "surface", "selection_bg": "selection",
                  "surface0": "surface", "surface1": "raised", "surface_dim": "surface",
                  "overlay0": "border", "overlay1": "muted", "subtext0": "muted",
                  "red": "red", "green": "green", "yellow": "yellow", "blue": "blue",
                  "mauve": "purple", "teal": "cyan", "peach": "orange"}
        text += "".join(f'{key} = "{p[value]}"\n' for key, value in fields.items())
    return text + "\n"


def replace_herdr_theme(text, state):
    # TOML has no include directive. Replace theme tables only, not keys/UI/commands.
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
    # Prepare and validate all changes before touching live files.
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
    # Reject prereleases: the first stable release that contributes Light is 1.2.0.
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
            source = str(pitch_vsix) if pitch_vsix is not None else PITCH_EXTENSION
            subprocess.run([cli, "--install-extension", source, "--force"], check=True, timeout=120)
            extensions = installed_extensions(cli)
        if not pitch_has_light(extensions.get(PITCH_EXTENSION, "")):
            raise ValueError(f"{app}: Xcode Pitch Theme 1.2.0+ is required. Until it is published, "
                             "run theme install --pitch-vsix /path/to/xcode-pitch-dark-theme-1.2.0.vsix")
        if AYU_EXTENSION not in extensions:
            subprocess.run([cli, "--install-extension", AYU_EXTENSION], check=True, timeout=120)
        # Remove only the provisional extension created by this theme setup.
        if LEGACY_EXTENSION in extensions:
            subprocess.run([cli, "--uninstall-extension", LEGACY_EXTENSION], check=True, timeout=30)


def install(reload=True, pitch_vsix=None):
    build()
    install_editors(pitch_vsix)
    for app in ("ghostty", "opencode"):
        for source in (GENERATED / app).iterdir():
            write(CONFIG / app / "themes" / source.name, source.read_text(), backup=True)
    apply(read_state(), reload=reload)
    print("Installed. Reload VSCode/Cursor windows and restart OpenCode once to discover the new themes.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", nargs="?", default="status",
                        choices=("auto", "dark", "light", "status", "build", "install"))
    parser.add_argument("--light", choices=("xcode", "ayu"), help="Light palette (also saved for auto mode)")
    parser.add_argument("--no-reload", action="store_true", help="Write configuration without contacting running apps")
    parser.add_argument("--pitch-vsix", type=Path, help="Install the official Xcode Pitch Theme from a local VSIX")
    args = parser.parse_args()
    if args.command == "build":
        build()
        print(GENERATED)
        return
    if args.command == "install":
        install(reload=not args.no_reload, pitch_vsix=args.pitch_vsix)
        return
    state = read_state()
    if args.command == "status":
        mode = system_mode() if state["mode"] == "auto" else state["mode"]
        print(f'{state["mode"]} ({mode}) · {state["light"]} · {STATE}')
        return
    if not (CONFIG / "opencode" / "themes" / "pitch-xcode-light.json").exists():
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
