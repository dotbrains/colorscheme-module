#!/usr/bin/env python3

import importlib.util
import pathlib
import sys
import tempfile
import tomllib
import unittest


ROOT = pathlib.Path(__file__).resolve().parents[1]
GENERATOR_PATH = ROOT / "scripts" / "generate-theme-adapters.py"
sys.path.insert(0, str(ROOT / "scripts"))

spec = importlib.util.spec_from_file_location("generate_theme_adapters", GENERATOR_PATH)
generate_theme_adapters = importlib.util.module_from_spec(spec)
spec.loader.exec_module(generate_theme_adapters)


class TestGenerateThemeAdapters(unittest.TestCase):
    def test_write_if_missing_creates_executable_scripts(self):
        with tempfile.TemporaryDirectory() as tempdir:
            script = pathlib.Path(tempdir) / "universal" / "new-theme.sh"

            created = generate_theme_adapters._write_if_missing(
                script,
                "#!/bin/bash\n\necho ok\n",
            )
            created_again = generate_theme_adapters._write_if_missing(
                script,
                "#!/bin/bash\n\necho overwritten\n",
            )

            self.assertTrue(created)
            self.assertFalse(created_again)
            self.assertIn("echo ok", script.read_text())
            self.assertTrue(script.stat().st_mode & 0o111)

    def test_starship_template_uses_manifest_palette(self):
        content = generate_theme_adapters._starship_config({
            "id": "sample-theme",
            "palette": {
                "background": "#000000",
                "foreground": "#ffffff",
                "selection": "#111111",
                "black": "#000000",
                "red": "#ff0000",
                "green": "#00ff00",
                "yellow": "#ffff00",
                "blue": "#0000ff",
                "magenta": "#ff00ff",
                "cyan": "#00ffff",
                "white": "#ffffff",
                "bright_black": "#111111",
                "bright_red": "#ff1111",
                "bright_green": "#11ff11",
                "bright_yellow": "#ffff11",
                "bright_blue": "#1111ff",
                "bright_magenta": "#ff11ff",
                "bright_cyan": "#11ffff",
                "bright_white": "#eeeeee",
            },
        })

        self.assertIn('palette = "sample_theme"', content)
        self.assertIn('red = "#ff0000"', content)

    def test_generated_starship_configs_are_valid_toml(self):
        for path in (ROOT / "_shared" / "configs" / "starship").glob("*.toml"):
            with self.subTest(path=path):
                tomllib.loads(path.read_text())


if __name__ == "__main__":
    unittest.main()
