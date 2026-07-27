#!/usr/bin/env python3

"""Print or scaffold adapter files from theme manifests."""

import argparse
import pathlib

import theme_registry


ROOT = pathlib.Path(__file__).resolve().parents[1]
SET_ME_UP_ROOT = ROOT.parents[1]
THEMES_DIR = ROOT / "themes"


def _display_name(theme):
    return theme.get("name", theme["id"])


def _shell_name(theme):
    return theme["id"]


def _write_if_missing(path, content):
    path = pathlib.Path(path)
    if path.exists():
        return False
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)
    if content.startswith("#!"):
        path.chmod(0o755)
    return True


def _universal_script(theme):
    theme_id = _shell_name(theme)
    name = _display_name(theme)
    bat = theme.get("bat", {}).get("theme", theme_id)
    lazygit_source = theme.get("lazygit", {}).get("source", "local")
    lazygit_config = theme_registry.lazygit_config(theme)

    return f"""#!/bin/bash

# shellcheck source=/dev/null

# Universal {name} colorscheme setup

declare current_dir &&
    current_dir="$(dirname "${{BASH_SOURCE[0]}}")" &&
    cd "${{current_dir}}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

source "../_shared/lib.sh"

main() {{

    action "Setting up {name} theme (universal)"

    install_bat_theme "" "{bat}"
    install_starship_config "{theme_id}"
    install_lazygit_theme "{theme_id}" "{lazygit_source}" "{lazygit_config}"
    install_alacritty_theme "{theme_id}"

    success "{name} theme setup complete (universal)"

}}

main
"""


def _macos_script(theme):
    theme_id = _shell_name(theme)
    name = _display_name(theme)

    return f"""#!/bin/bash

# shellcheck source=/dev/null

# macOS {name} colorscheme setup

declare current_dir &&
    current_dir="$(dirname "${{BASH_SOURCE[0]}}")" &&
    cd "${{current_dir}}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

source "../_shared/lib.sh"

main() {{

    action "Setting up {name} theme (macOS)"
    bash ../universal/{theme_id}.sh
    success "{name} theme setup complete (macOS)"

}}

main
"""


def _arch_script(theme):
    theme_id = _shell_name(theme)
    name = _display_name(theme)

    return f"""#!/bin/bash

# shellcheck source=/dev/null

# Arch Linux {name} colorscheme setup

declare current_dir &&
    current_dir="$(dirname "${{BASH_SOURCE[0]}}")" &&
    cd "${{current_dir}}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

source "../_shared/lib.sh"

main() {{

    action "Setting up {name} theme (Arch Linux)"
    bash ../universal/{theme_id}.sh
    success "{name} theme setup complete (Arch Linux)"

}}

main
"""


def _starship_config(theme):
    theme_id = _shell_name(theme).replace("-", "_")

    return f"""# TODO: tune this palette for {theme['id']}.
palette = "{theme_id}"

[character]
success_symbol = "[>](green)"
error_symbol = "[>](red)"

[palettes.{theme_id}]
red = "#ff5555"
green = "#50fa7b"
yellow = "#f1fa8c"
blue = "#8be9fd"
purple = "#bd93f9"
"""


def _lazygit_config(theme):
    return f"""# TODO: tune this lazygit palette for {theme['id']}.
gui:
  theme:
    activeBorderColor:
      - '#8be9fd'
      - bold
    inactiveBorderColor:
      - '#6272a4'
    selectedLineBgColor:
      - '#44475a'
    defaultFgColor:
      - '#f8f8f2'
"""


def _alacritty_theme(theme):
    return f"""# TODO: tune this Alacritty palette for {theme['id']}.
[colors.primary]
background = "#282a36"
foreground = "#f8f8f2"

[colors.normal]
black = "#21222c"
red = "#ff5555"
green = "#50fa7b"
yellow = "#f1fa8c"
blue = "#8be9fd"
magenta = "#bd93f9"
cyan = "#8be9fd"
white = "#f8f8f2"
"""


def _tmux_theme(theme):
    return f"""# TODO: tune this tmux palette for {theme['id']}.
set -g status-style "bg=#282a36,fg=#f8f8f2"
set -g message-style "bg=#44475a,fg=#f8f8f2"
set -g pane-border-style "fg=#44475a"
set -g pane-active-border-style "fg=#8be9fd"
"""


def _zsh_adapter(theme, kind):
    return f"""#!/usr/bin/env zsh
# TODO: tune this {kind} adapter for {theme['id']}.
"""


def _nvim_plugin(theme):
    colorscheme = theme_registry.nvim_colorscheme(theme)
    return f"""return {{
    -- TODO: add the real plugin and configure colorscheme "{colorscheme}".
}}
"""


def _scaffold_content(label, theme):
    if label == "universal script":
        return _universal_script(theme)
    if label == "macos script":
        return _macos_script(theme)
    if label == "arch script":
        return _arch_script(theme)
    if label == "starship config":
        return _starship_config(theme)
    if label == "lazygit config":
        return _lazygit_config(theme)
    if label == "alacritty theme":
        return _alacritty_theme(theme)
    if label == "tmux theme":
        return _tmux_theme(theme)
    if label.startswith("zsh "):
        return _zsh_adapter(theme, label.removeprefix("zsh ").removesuffix(" theme"))
    if label == "nvim plugin":
        return _nvim_plugin(theme)
    return None


def _themes(selected):
    themes = theme_registry.theme_by_id(THEMES_DIR)
    if selected:
        missing = [theme_id for theme_id in selected if theme_id not in themes]
        if missing:
            raise SystemExit(f"Unknown theme(s): {', '.join(missing)}")
        return [themes[theme_id] for theme_id in selected]
    return [themes[theme_id] for theme_id in sorted(themes)]


def _print_inventory(themes, aggregate_root):
    for theme in themes:
        print(theme["id"])
        for label, path in theme_registry.adapter_paths(ROOT, theme, aggregate_root):
            print(f"  {label}: {path.relative_to(aggregate_root or ROOT)}")


def _scaffold(themes, aggregate_root):
    created = []
    skipped = []

    for theme in themes:
        for label, path in theme_registry.adapter_paths(ROOT, theme, aggregate_root):
            content = _scaffold_content(label, theme)
            if content is None:
                continue
            if _write_if_missing(path, content):
                created.append(path)
            else:
                skipped.append(path)

    for path in created:
        print(f"created {path}")
    for path in skipped:
        print(f"exists  {path}")
    print(f"Scaffolded {len(created)} file(s); skipped {len(skipped)} existing file(s).")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("themes", nargs="*", help="Theme IDs to print or scaffold.")
    parser.add_argument(
        "--scaffold",
        action="store_true",
        help="Create missing adapter files for the selected theme manifests.",
    )
    parser.add_argument(
        "--aggregate",
        action="store_true",
        help="Include cross-repo adapters from an aggregate set-me-up checkout.",
    )
    args = parser.parse_args()

    aggregate_root = SET_ME_UP_ROOT if args.aggregate else None
    selected_themes = _themes(args.themes)

    if args.scaffold:
        _scaffold(selected_themes, aggregate_root)
        return

    _print_inventory(selected_themes, aggregate_root)


if __name__ == "__main__":
    main()
