#!/bin/bash

# shellcheck source=/dev/null

# Universal Nord colorscheme setup
# Configures cross-platform tools: fish, bat, starship

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

# Load shared functions
source "../_shared/lib.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    action "Setting up Nord theme (universal)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Fish shell theme
    install_fish_theme "nordtheme/fish" "Nord"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Starship prompt
    install_starship_config "nord"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Lazygit theme
    install_lazygit_theme "nord" "local" "nord.yml"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    success "Nord theme setup complete (universal)"

}

main
