#!/bin/bash

# shellcheck source=/dev/null

# macOS Catppuccin colorscheme setup
# Handles macOS-specific configuration (Terminal.app, wallpaper)
# Then calls universal setup for cross-platform tools

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

# Load shared functions
source "../_shared/lib.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    action "Setting up Catppuccin theme (macOS)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Set wallpaper
    set_wallpaper "catppuccin" "black-hole.png"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Apply Terminal.app theme
    if cmd_exists "osascript"; then
        action "Applying Terminal.app theme: Catppuccin"
        osascript terminal/apply_theme.applescript "Catppuccin"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Run universal setup (fish, bat, starship, lazygit)
    bash ../universal/catppuccin.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    success "Catppuccin theme setup complete (macOS)"

}

main
