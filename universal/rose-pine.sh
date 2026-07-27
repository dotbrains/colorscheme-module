#!/bin/bash

# shellcheck source=/dev/null

# Universal Rose Pine colorscheme setup

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

source "../_shared/lib.sh"

main() {
    action "Setting up Rose Pine theme (universal)"
    install_fish_theme "jorgebucaran/hydro" "Rose Pine"
    install_bat_theme "https://github.com/rose-pine/tm-theme" "rose-pine"
    install_starship_config "rose-pine"
    install_lazygit_theme "rose-pine" "local" "rose-pine.yml"
    install_alacritty_theme "rose-pine"
    success "Rose Pine theme setup complete (universal)"
}

main
