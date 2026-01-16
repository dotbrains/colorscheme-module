#!/bin/bash

# shellcheck source=/dev/null

# macOS Nord colorscheme setup
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

    action "Setting up Nord theme (macOS)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Set wallpaper
    set_wallpaper "nord" "nord-dark-space-exploration.png"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Apply Terminal.app theme
    if cmd_exists "osascript"; then
        action "Applying Terminal.app theme: Nord"
        osascript terminal/apply_theme.applescript "Nord"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Run universal setup (fish, bat, starship)
    bash ../universal/nord.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    success "Nord theme setup complete (macOS)"

}

main
