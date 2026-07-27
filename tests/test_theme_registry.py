#!/usr/bin/env python3

import pathlib
import sys
import tempfile
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))

import theme_registry


class TestThemeRegistry(unittest.TestCase):
    def test_reads_sectioned_manifest(self):
        with tempfile.TemporaryDirectory() as tempdir:
            themes_dir = pathlib.Path(tempdir)
            manifest = themes_dir / "tokyo-night.toml"
            manifest.write_text(
                'id = "tokyo-night"\n'
                "[nvim]\n"
                'colorscheme = "tokyonight"\n'
                "[lazygit]\n"
                'source = "repo"\n'
            )

            themes = theme_registry.theme_by_id(themes_dir)

            self.assertEqual(themes["tokyo-night"]["nvim"]["colorscheme"], "tokyonight")
            self.assertFalse(theme_registry.lazygit_is_local(themes["tokyo-night"]))

    def test_adapter_paths_respect_local_mode(self):
        theme = {
            "id": "tokyo-night",
            "nvim": {"colorscheme": "tokyonight"},
            "lazygit": {"source": "repo"},
        }

        local_paths = theme_registry.adapter_paths("/repo/colorschemes", theme)
        aggregate_paths = theme_registry.adapter_paths(
            "/repo/colorschemes",
            theme,
            aggregate_root="/repo",
        )

        self.assertFalse(any(label == "lazygit config" for label, _path in local_paths))
        self.assertTrue(any(label == "nvim plugin" for label, _path in aggregate_paths))


if __name__ == "__main__":
    unittest.main()
