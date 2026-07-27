#!/usr/bin/env python3

"""Shared theme manifest and adapter contract helpers."""

import pathlib
import re


def read_manifest(path):
    data = {}
    current_section = None

    for raw_line in pathlib.Path(path).read_text().splitlines():
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


def manifests(themes_dir):
    return [
        read_manifest(path)
        for path in sorted(pathlib.Path(themes_dir).glob("*.toml"))
    ]


def theme_by_id(themes_dir):
    return {
        theme["id"]: theme
        for theme in manifests(themes_dir)
        if theme.get("id")
    }


def theme_id(theme):
    return theme["id"]


def manifest_file(theme):
    return f"{theme_id(theme)}.toml"


def starship_config(theme):
    return theme.get("starship", {}).get("config", f"{theme_id(theme)}.toml")


def lazygit_config(theme):
    return theme.get("lazygit", {}).get("config", f"{theme_id(theme)}.yml")


def lazygit_is_local(theme):
    return theme.get("lazygit", {}).get("source", "local") == "local"


def alacritty_theme(theme):
    return theme.get("alacritty", {}).get("theme", f"{theme_id(theme)}.toml")


def tmux_theme(theme):
    return theme.get("tmux", {}).get("theme", f"{theme_id(theme)}.conf")


def nvim_colorscheme(theme):
    return theme.get("nvim", {}).get("colorscheme", theme_id(theme))


def adapter_paths(colorscheme_root, theme, aggregate_root=None):
    colorscheme_root = pathlib.Path(colorscheme_root)
    theme_name = theme_id(theme)
    paths = [
        ("colorscheme manifest", colorscheme_root / "themes" / manifest_file(theme)),
        ("universal script", colorscheme_root / "universal" / f"{theme_name}.sh"),
        ("macos script", colorscheme_root / "macos" / f"{theme_name}.sh"),
        ("arch script", colorscheme_root / "arch" / f"{theme_name}.sh"),
        (
            "starship config",
            colorscheme_root / "_shared" / "configs" / "starship" / starship_config(theme),
        ),
    ]

    if lazygit_is_local(theme):
        paths.append((
            "lazygit config",
            colorscheme_root / "_shared" / "configs" / "lazygit" / lazygit_config(theme),
        ))

    if aggregate_root is None:
        return paths

    aggregate_root = pathlib.Path(aggregate_root)
    paths.extend([
        (
            "alacritty theme",
            aggregate_root / "home" / ".config" / "alacritty" / "theme" / alacritty_theme(theme),
        ),
        (
            "tmux theme",
            aggregate_root / "home" / ".config" / "tmux" / "themes" / tmux_theme(theme),
        ),
        (
            "zsh bat theme",
            aggregate_root / "home" / ".config" / "zsh" / "themes" / theme_name / "bat.zsh",
        ),
        (
            "zsh fzf theme",
            aggregate_root / "home" / ".config" / "zsh" / "themes" / theme_name / "fzf.zsh",
        ),
        (
            "zsh dircolors theme",
            aggregate_root / "home" / ".config" / "zsh" / "themes" / theme_name / "dircolors.zsh",
        ),
        (
            "nvim plugin",
            aggregate_root
            / "home"
            / ".config"
            / "nvim"
            / "lua"
            / "plugins"
            / "ui"
            / f"{nvim_colorscheme(theme)}.lua",
        ),
    ])

    return paths
