#!/bin/bash

# shellcheck source=/dev/null

# Universal Tokyo Night colorscheme setup

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

source "../_shared/lib.sh"

main() {
    action "Setting up Tokyo Night theme (universal)"
    install_fish_theme "jorgebucaran/hydro" "TokyoNight Night"
    install_bat_theme "https://github.com/enkia/tokyo-night-vscode-theme" "tokyo-night"
    install_starship_config "tokyo-night"
    install_lazygit_theme "tokyo-night" "local" "tokyo-night.yml"
    install_alacritty_theme "tokyo-night"
    success "Tokyo Night theme setup complete (universal)"
}

main
