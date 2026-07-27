#!/usr/bin/env python3

import pathlib
import re
import sys


ROOT = pathlib.Path(__file__).resolve().parents[1]
SET_ME_UP_ROOT = ROOT.parents[1]
THEMES_DIR = ROOT / "themes"


def _read_manifest(path):
    data = {}
    current_section = None

    for raw_line in path.read_text().splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        section_match = re.match(r"^\[([A-Za-z0-9_-]+)\]$", line)
        if section_match:
            current_section = section_match.group(1)
            data.setdefault(current_section, {})
            continue
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        key = key.strip()
        value = value.strip().strip('"').strip("'")
        if current_section:
            data[current_section][key] = value
        else:
            data[key] = value

    return data


def manifests():
    return [_read_manifest(path) for path in sorted(THEMES_DIR.glob("*.toml"))]


def required_paths(theme):
    theme_id = theme["id"]
    lazygit = theme.get("lazygit", {})
    lazygit_config = lazygit.get("config", f"{theme_id}.yml")
    starship_config = theme.get("starship", {}).get("config", f"{theme_id}.toml")
    alacritty_theme = theme.get("alacritty", {}).get("theme", f"{theme_id}.toml")
    tmux_theme = theme.get("tmux", {}).get("theme", f"{theme_id}.conf")
    nvim_colorscheme = theme.get("nvim", {}).get("colorscheme", theme_id)

    paths = [
        ROOT / "universal" / f"{theme_id}.sh",
        ROOT / "macos" / f"{theme_id}.sh",
        ROOT / "arch" / f"{theme_id}.sh",
        ROOT / "_shared" / "configs" / "starship" / starship_config,
        SET_ME_UP_ROOT / "home" / ".config" / "alacritty" / "theme" / alacritty_theme,
        SET_ME_UP_ROOT / "home" / ".config" / "tmux" / "themes" / tmux_theme,
        SET_ME_UP_ROOT / "home" / ".config" / "zsh" / "themes" / theme_id / "bat.zsh",
        SET_ME_UP_ROOT / "home" / ".config" / "zsh" / "themes" / theme_id / "fzf.zsh",
        SET_ME_UP_ROOT / "home" / ".config" / "zsh" / "themes" / theme_id / "dircolors.zsh",
        SET_ME_UP_ROOT / "home" / ".config" / "nvim" / "lua" / "plugins" / "ui" / f"{nvim_colorscheme}.lua",
    ]

    if lazygit.get("source", "local") == "local":
        paths.append(ROOT / "_shared" / "configs" / "lazygit" / lazygit_config)

    return paths


def main():
    failed = False
    seen = set()

    for theme in manifests():
        theme_id = theme.get("id")
        if not theme_id:
            print("FAIL manifest missing id")
            failed = True
            continue
        if theme_id in seen:
            print(f"FAIL duplicate theme id: {theme_id}")
            failed = True
        seen.add(theme_id)

        missing = [path for path in required_paths(theme) if not path.exists()]
        if missing:
            failed = True
            print(f"FAIL {theme_id}")
            for path in missing:
                print(f"  missing {path}")
        else:
            print(f"OK   {theme_id}")

    if failed:
        return 1
    print(f"Validated {len(seen)} theme(s).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
