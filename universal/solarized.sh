#!/bin/bash

# shellcheck source=/dev/null

# Universal Solarized colorscheme setup

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

source "../_shared/lib.sh"

main() {
    action "Setting up Solarized theme (universal)"
    install_fish_theme "jorgebucaran/hydro" "Solarized Dark"
    install_bat_theme "https://github.com/braver/Solarized" "solarized"
    install_starship_config "solarized"
    install_lazygit_theme "solarized" "local" "solarized.yml"
    install_alacritty_theme "solarized"
    success "Solarized theme setup complete (universal)"
}

main
