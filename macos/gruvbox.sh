#!/bin/bash

# shellcheck source=/dev/null

# macOS Gruvbox colorscheme setup
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

    action "Setting up Gruvbox theme (macOS)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Set wallpaper
    set_wallpaper "gruvbox" "grassland.jpg"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Apply Terminal.app theme
    if cmd_exists "osascript"; then
        action "Applying Terminal.app theme: Gruvbox"
        osascript terminal/apply_theme.applescript "Gruvbox"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Run universal setup (fish, bat, starship)
    bash ../universal/gruvbox.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    success "Gruvbox theme setup complete (macOS)"

}

main
