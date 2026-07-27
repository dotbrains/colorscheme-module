#!/bin/bash

# shellcheck source=/dev/null

# Universal Everforest colorscheme setup

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

source "../_shared/lib.sh"

main() {
    action "Setting up Everforest theme (universal)"
    install_fish_theme "jorgebucaran/hydro" "Everforest"
    install_bat_theme "https://github.com/sainnhe/everforest" "everforest"
    install_starship_config "everforest"
    install_lazygit_theme "everforest" "local" "everforest.yml"
    install_alacritty_theme "everforest"
    success "Everforest theme setup complete (universal)"
}

main
