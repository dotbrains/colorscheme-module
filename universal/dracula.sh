#!/bin/bash

# shellcheck source=/dev/null

# Universal Dracula colorscheme setup

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

source "../_shared/lib.sh"

main() {
    action "Setting up Dracula theme (universal)"
    install_fish_theme "dracula/fish" "Dracula Official"
    install_bat_theme "https://github.com/dracula/sublime" "dracula"
    install_starship_config "dracula"
    install_lazygit_theme "dracula" "local" "dracula.yml"
    install_alacritty_theme "dracula"
    success "Dracula theme setup complete (universal)"
}

main
