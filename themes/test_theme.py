import json
import io
import os
from pathlib import Path
import tarfile
import tempfile
import tomllib
import unittest
from unittest.mock import patch

import theme
import source


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
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        root = Path(temporary.name)
        replacement = patch.object(theme, "STATE", root / "state.json")
        replacement.start()
        self.addCleanup(replacement.stop)
        self.install_fragments(root)

    @staticmethod
    def install_fragments(root):
        (root / "herdr").mkdir(parents=True, exist_ok=True)
        for variant in ("xcode", "ayu"):
            for mode in ("auto", "dark", "light"):
                (root / "herdr" / f"{variant}-{mode}.toml").write_text(
                    f'[theme]\nname = "terminal"\nauto_switch = {str(mode == "auto").lower()}\n\n')

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

    def test_official_extension_version_must_include_light(self):
        for version in ("", "1.1.0", "1.2.0-beta.1", "invalid"):
            self.assertFalse(theme.pitch_has_light(version), version)
        for version in ("1.2.0", "1.2.1", "1.10.0", "2.0.0"):
            self.assertTrue(theme.pitch_has_light(version), version)

    def test_editors_select_official_themes(self):
        self.assertEqual(theme.EDITOR_THEMES["xcode-dark"], "Xcode Pitch Dark Theme")
        self.assertEqual(theme.EDITOR_THEMES["xcode-light"], "Xcode Pitch Light")
        self.assertEqual(theme.EDITOR_THEMES["ayu-light"], "Ayu Light")

    def test_editor_auto_and_manual(self):
        for mode in ("auto", "dark", "light"):
            with patch.object(theme, "system_mode", return_value="light"):
                settings = theme.editor_settings({"mode": mode, "light": "ayu-light"})
            self.assertEqual(settings["window.autoDetectColorScheme"], mode == "auto")
            self.assertEqual(settings["workbench.colorTheme"], theme.EDITOR_THEMES["xcode-dark" if mode == "dark" else "ayu-light"])

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

    def test_only_our_herdr_symlink_is_detached_without_losing_preferences(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            template = root / "herdr/config/config.toml"
            template.parent.mkdir(parents=True)
            template.write_text('onboarding = false\n[keys]\nprefix = "ctrl+h"\n')
            active = root / "active.toml"
            active.symlink_to(template)
            with patch.object(theme, "ROOT", root), patch.object(theme, "paths", return_value={"herdr": active}):
                theme.detach_herdr_template()
            self.assertFalse(active.is_symlink())
            self.assertEqual(active.read_text(), template.read_text())

    def test_apply_round_trip_keeps_other_preferences(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            self.install_fragments(root / "runtime")
            paths = {name: root / name for name in ("ghostty", "opencode", "herdr", "VSCode", "Cursor")}
            paths["ghostty"].write_text('font-size = 14\ntheme = old\n')
            paths["herdr"].write_text('onboarding = false\n[theme]\nname = "nord"\n[keys]\nprefix = "ctrl+h"\n')
            paths["opencode"].write_text('{"theme":{"name":"old"}, "plugins":["./herdr-opencode"]}')
            for name in ("VSCode", "Cursor"):
                paths[name].write_text('{// Keep\n"editor.fontSize": 14,}')
            with patch.object(theme, "paths", return_value=paths), patch.object(theme, "STATE", root / "runtime/state.json"):
                for mode in ("dark", "light", "auto"):
                    state = {"mode": mode, "light": "ayu-light"}
                    theme.apply(state, reload=False)
                    self.assertEqual(theme.apply(state, reload=False), [])
                    self.assertEqual(theme.load_jsonc(paths["opencode"].read_text())["plugins"], ["./herdr-opencode"])
                    self.assertEqual(tomllib.loads(paths["herdr"].read_text())["keys"]["prefix"], "ctrl+h")
                    self.assertIn('// Keep', paths["VSCode"].read_text())
                    self.assertIn('font-size = 14', paths["ghostty"].read_text())
                    self.assertEqual(theme.read_state(), state)


class SourceTests(unittest.TestCase):
    def test_source_lock_uses_an_immutable_commit(self):
        lock = json.loads(source.LOCK.read_text())
        self.assertEqual(lock["repository"], "achamorro-dev/xcode-pitch-theme")
        self.assertRegex(lock["revision"], r"^[0-9a-f]{40}$")

    @staticmethod
    def archive(name, link=False):
        data = io.BytesIO()
        with tarfile.open(fileobj=data, mode="w:gz") as archive:
            member = tarfile.TarInfo(name)
            if link:
                member.type = tarfile.SYMTYPE
                member.linkname = "/outside"
                archive.addfile(member)
            else:
                member.size = 2
                archive.addfile(member, io.BytesIO(b"{}"))
        return data.getvalue()

    def test_archive_rejects_traversal_and_links(self):
        with tempfile.TemporaryDirectory() as temp:
            for name in ("root/../outside", "/root/absolute", "root/palettes/../../outside"):
                with self.assertRaises(ValueError):
                    source.extract_archive(self.archive(name), Path(temp))
            with self.assertRaises(ValueError):
                source.extract_archive(self.archive("root/scripts/link", link=True), Path(temp))

    def test_archive_extracts_only_required_source_directories(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            source.extract_archive(self.archive("root/palettes/light.json"), root)
            self.assertEqual((root / "palettes/light.json").read_text(), "{}")
            source.extract_archive(self.archive("root/images/ignore.json"), root)
            self.assertFalse((root / "images").exists())

    def test_cached_revision_is_reused_without_network(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            revision = "a" * 40
            cached = root / revision
            for relative in source.REQUIRED:
                path = cached / relative
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("{}")
            (cached / "package.json").write_text(json.dumps({"publisher": "albertochamorro", "name": "xcode-pitch-dark-theme"}))
            lock = root / "lock.json"
            lock.write_text(json.dumps({"repository": "achamorro-dev/xcode-pitch-theme", "revision": revision}))
            with patch.object(source, "LOCK", lock), patch.object(source, "CACHE", root), patch.dict(os.environ, {"XCODE_PITCH_SOURCE": ""}), patch("urllib.request.urlopen") as network:
                self.assertEqual(source.resolve(), cached.resolve())
                network.assert_not_called()

    def test_incomplete_source_fails_before_import(self):
        with tempfile.TemporaryDirectory() as temp:
            with self.assertRaises(ValueError):
                source.validate(Path(temp))


if __name__ == "__main__":
    unittest.main()
