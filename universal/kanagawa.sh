#!/bin/bash

# shellcheck source=/dev/null

# Universal Kanagawa colorscheme setup

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

source "../_shared/lib.sh"

main() {
    action "Setting up Kanagawa theme (universal)"
    install_fish_theme "jorgebucaran/hydro" "Kanagawa"
    install_bat_theme "https://github.com/rebelot/kanagawa.nvim" "kanagawa"
    install_starship_config "kanagawa"
    install_lazygit_theme "kanagawa" "local" "kanagawa.yml"
    install_alacritty_theme "kanagawa"
    success "Kanagawa theme setup complete (universal)"
}

main
