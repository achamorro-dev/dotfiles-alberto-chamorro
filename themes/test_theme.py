import json
from pathlib import Path
import tempfile
import tomllib
import unittest
from unittest.mock import patch

import theme


class JsoncTests(unittest.TestCase):
    def test_strings_comments_nested_objects_and_trailing_commas(self):
        text = '''{
  // Keep my settings
  "url": "https://example.test/*not-comment*/",
  "nested": {"mode": "leave", "array": [1, 2,],},
  "workbench.colorTheme": "old", // Theme comment
}'''
        result = theme.update_jsonc(text, {"workbench.colorTheme": "new", "auto": True})
        self.assertIn('// Keep my settings', result)
        self.assertIn('"nested": {"mode": "leave", "array": [1, 2,],}', result)
        self.assertIn('// Theme comment', result)
        self.assertEqual(theme.load_jsonc(result)["url"], "https://example.test/*not-comment*/")
        self.assertEqual(theme.load_jsonc(result)["workbench.colorTheme"], "new")
        self.assertEqual(theme.update_jsonc(result, {"workbench.colorTheme": "new", "auto": True}), result)

    def test_insert_after_inline_comment_without_trailing_comma(self):
        result = theme.update_jsonc('{"x": 1 // keep\n}', {"y": 2})
        self.assertEqual(theme.load_jsonc(result), {"x": 1, "y": 2})
        self.assertIn('// keep', result)

    def test_empty_and_escaped_strings(self):
        self.assertEqual(theme.load_jsonc(theme.update_jsonc('{}', {"mode": "auto"})), {"mode": "auto"})
        text = json.dumps({"quote": '"\\//', "theme": {"name": "old", "mode": "dark"}})
        self.assertEqual(theme.load_jsonc(theme.update_jsonc(text, {"theme": {"mode": "system"}}))["quote"], '"\\//')

    def test_reject_duplicate_setting_when_replacing(self):
        with self.assertRaises(ValueError):
            theme.update_jsonc('{"x": 1, "x": 2}', {"x": 3})


class ThemeTests(unittest.TestCase):
    def test_herdr_preserves_root_and_unrelated_tables_for_all_modes(self):
        original = theme.ROOT.joinpath("herdr/config/config.toml").read_text()
        before = tomllib.loads(original)
        before.pop("theme", None)
        for mode in ("auto", "dark", "light", "auto"):
            for light in ("xcode-light", "ayu-light"):
                state = {"mode": mode, "light": light}
                result = theme.replace_herdr_theme(original, state)
                parsed = tomllib.loads(result)
                self.assertEqual(parsed["theme"]["auto_switch"], mode == "auto")
                parsed.pop("theme")
                self.assertEqual(parsed, before)
                self.assertEqual(theme.replace_herdr_theme(result, state), result)
                original = result

    def test_theme_generation_and_v2_references(self):
        theme.build()
        for path in (theme.GENERATED / "opencode").glob("*.json"):
            data = json.loads(path.read_text())
            self.assertNotIn("defs", data)
            self.assertNotIn("theme", data)
            for mode in ("dark", "light"):
                resolved = {**data["base"], **data[mode]}

                def resolve(value, stack=()):
                    if isinstance(value, dict):
                        return {k: resolve(v, stack) for k, v in value.items()}
                    if isinstance(value, list):
                        return [resolve(v, stack) for v in value]
                    if not value.startswith("$"):
                        return value
                    self.assertNotIn(value, stack)
                    target = resolved
                    for part in value[1:].split("."):
                        target = target[part]
                    return resolve(target, (*stack, value))

                resolve(resolved)
                self.assertEqual(set(resolved["syntax"]), {"comment", "keyword", "function", "variable", "string", "number", "type", "operator", "punctuation"})

    def test_official_extension_version_must_include_light(self):
        for version in ("", "1.1.0", "1.2.0-beta.1", "invalid"):
            self.assertFalse(theme.pitch_has_light(version), version)
        for version in ("1.2.0", "1.2.1", "1.10.0", "2.0.0"):
            self.assertTrue(theme.pitch_has_light(version), version)

    def test_editors_select_official_themes(self):
        self.assertEqual(theme.PALETTES["xcode-dark"]["name"], "Xcode Pitch Dark Theme")
        self.assertEqual(theme.PALETTES["xcode-light"]["name"], "Xcode Pitch Light")
        self.assertEqual(theme.PALETTES["ayu-light"]["name"], "Ayu Light")

    def test_light_syntax_contrast(self):
        def luminance(hex_color):
            channels = [int(hex_color[i:i+2], 16) / 255 for i in (1, 3, 5)]
            linear = [v / 12.92 if v <= .04045 else ((v + .055) / 1.055) ** 2.4 for v in channels]
            return sum(a * b for a, b in zip(linear, (.2126, .7152, .0722)))

        p = theme.PALETTES["xcode-light"]
        for role in ("foreground", "muted", "comment", "keyword", "function", "variable", "string", "number", "type", "operator", "punctuation"):
            ratio = (luminance(p["background"]) + .05) / (luminance(p[role]) + .05)
            self.assertGreaterEqual(ratio, 4.5, role)

    def test_editor_auto_and_manual(self):
        for mode in ("auto", "dark", "light"):
            with patch.object(theme, "system_mode", return_value="light"):
                settings = theme.editor_settings({"mode": mode, "light": "ayu-light"})
            self.assertEqual(settings["window.autoDetectColorScheme"], mode == "auto")
            self.assertEqual(settings["workbench.colorTheme"], theme.PALETTES["xcode-dark" if mode == "dark" else "ayu-light"]["name"])

    def test_atomic_write_preserves_symlink_and_original_backup(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp)
            target, link = path / "source", path / "linked"
            target.write_text("original")
            link.symlink_to(target)
            self.assertTrue(theme.write(link, "first", backup=True))
            self.assertTrue(link.is_symlink())
            theme.write(link, "second", backup=True)
            self.assertEqual(target.with_name("source.before-dotfiles-theme").read_text(), "original")
            self.assertFalse(theme.write(link, "second", backup=True))

    def test_apply_round_trip_keeps_other_preferences(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            paths = {name: root / name for name in ("ghostty", "opencode", "herdr", "VSCode", "Cursor")}
            paths["ghostty"].write_text('font-size = 14\ntheme = old\n')
            paths["herdr"].write_text('onboarding = false\n[theme]\nname = "nord"\n[keys]\nprefix = "ctrl+h"\n')
            paths["opencode"].write_text('{"theme":{"name":"old"}, "plugins":["./herdr-opencode"]}')
            for name in ("VSCode", "Cursor"):
                paths[name].write_text('{// Keep\n"editor.fontSize": 14,}')
            with patch.object(theme, "paths", return_value=paths), patch.object(theme, "STATE", root / "state.json"):
                for mode in ("dark", "light", "auto"):
                    state = {"mode": mode, "light": "ayu-light"}
                    theme.apply(state, reload=False)
                    self.assertEqual(theme.apply(state, reload=False), [])
                    self.assertEqual(theme.load_jsonc(paths["opencode"].read_text())["plugins"], ["./herdr-opencode"])
                    self.assertEqual(tomllib.loads(paths["herdr"].read_text())["keys"]["prefix"], "ctrl+h")
                    self.assertIn('// Keep', paths["VSCode"].read_text())
                    self.assertIn('font-size = 14', paths["ghostty"].read_text())
                    self.assertEqual(theme.read_state(), state)


if __name__ == "__main__":
    unittest.main()
