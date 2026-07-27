#!/usr/bin/env python3

"""Generate adapter inventory from theme manifests.

This script is intentionally conservative: it reports the files each adapter
owns and delegates contract enforcement to `theme_contract.py`. The adapter
files stay committed so shells and tools can load them without a build step.
"""

import pathlib
import re


ROOT = pathlib.Path(__file__).resolve().parents[1]


def manifest_ids():
    ids = []
    for path in sorted((ROOT / "themes").glob("*.toml")):
        match = re.search(r'^id\s*=\s*"([^"]+)"', path.read_text(), re.MULTILINE)
        if match:
            ids.append(match.group(1))
    return ids


def main():
    for theme_id in manifest_ids():
        print(theme_id)
        print(f"  colorscheme: universal/{theme_id}.sh")
        print(f"  shell:       zsh/themes/{theme_id}/")
        print(f"  terminal:    alacritty/theme/{theme_id}.toml")
        print(f"  tmux:        tmux/themes/{theme_id}.conf")


if __name__ == "__main__":
    main()
