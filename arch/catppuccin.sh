#!/bin/bash

# shellcheck source=/dev/null

# Arch Linux Catppuccin colorscheme setup
# Handles Arch-specific configuration (wallpaper, terminal themes)
# Then calls universal setup for cross-platform tools

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

# Load shared functions
source "../_shared/lib.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    action "Setting up Catppuccin theme (Arch Linux)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Set wallpaper
    set_wallpaper "catppuccin" "pastel-mountains.jpg"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Run universal setup (fish, bat, starship)
    bash ../universal/catppuccin.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    success "Catppuccin theme setup complete (Arch Linux)"

}

main
