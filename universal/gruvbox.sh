#!/bin/bash

# shellcheck source=/dev/null

# Universal Gruvbox colorscheme setup
# Configures cross-platform tools: fish, bat, starship

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

# Load shared functions
source "../_shared/lib.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    action "Setting up Gruvbox theme (universal)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Fish shell theme
    install_fish_theme "Jomik/fish-gruvbox" "Gruvbox Dark"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Bat theme
    install_bat_theme "https://github.com/peaceant/gruvbox-material-bat" "gruvbox"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Starship prompt
    install_starship_config "gruvbox"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Lazygit theme
    install_lazygit_theme "gruvbox" "local" "gruvbox.yml"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    success "Gruvbox theme setup complete (universal)"

}

main
