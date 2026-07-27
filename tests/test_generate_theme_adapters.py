#!/usr/bin/env python3

import importlib.util
import pathlib
import sys
import tempfile
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


if __name__ == "__main__":
    unittest.main()
