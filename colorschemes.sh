#!/bin/bash

# shellcheck source=/dev/null

# Colorschemes Configuration
#
# Multi-OS colorscheme setup with support for:
# - macOS: Terminal.app, wallpaper
# - Arch Linux: wallpaper, terminal themes
# - Debian/Ubuntu: GNOME Terminal, wallpaper
# - Universal: fish, bat, starship, lazygit
#
# @author Nicholas Adamou

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source /dev/stdin <<<"$(curl -s "https://raw.githubusercontent.com/dotbrains/utilities/master/utilities.sh")"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Configuration: Select your preferred colorscheme
# Options: gruvbox, nord, catppuccin
COLORSCHEME="gruvbox"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install required packages via Homebrew
    if cmd_exists "brew"; then
        brew_bundle_install -f "brewfile"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Close any open `System Preferences` panes on macOS
    if is_macos; then
        ./close_system_preferences_panes.applescript 2>/dev/null || true
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Apply colorscheme based on OS
    if is_macos; then
        action "Applying ${COLORSCHEME} colorscheme (macOS)"
        bash "macos/${COLORSCHEME}.sh"
    elif is_arch; then
        action "Applying ${COLORSCHEME} colorscheme (Arch Linux)"
        bash "arch/${COLORSCHEME}.sh"
    elif is_debian; then
        action "Applying ${COLORSCHEME} colorscheme (Debian)"
        # Debian-specific scripts can be added here
        # bash "debian/${COLORSCHEME}.sh"
        # For now, fall back to universal
        bash "universal/${COLORSCHEME}.sh"
    else
        action "Applying ${COLORSCHEME} colorscheme (universal)"
        bash "universal/${COLORSCHEME}.sh"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    success "Colorscheme setup complete"

}

main
