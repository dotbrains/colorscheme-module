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

SUPPORTED_COLORSCHEMES="gruvbox nord catppuccin"
DEFAULT_COLORSCHEME="gruvbox"

load_profile() {
    local profile="${XDG_CONFIG_HOME:-$HOME/.config}/set-me-up/profile.env"
    local env_theme="${SMU_THEME:-}"

    if [ -f "$profile" ]; then
        # shellcheck source=/dev/null
        source "$profile"
    fi

    if [ -n "$env_theme" ]; then
        SMU_THEME="$env_theme"
    fi
}

is_supported_colorscheme() {
    local colorscheme="$1"

    for supported in $SUPPORTED_COLORSCHEMES; do
        if [ "$supported" = "$colorscheme" ]; then
            return 0
        fi
    done

    return 1
}

resolve_colorscheme() {
    local colorscheme="${1:-${SMU_THEME:-$DEFAULT_COLORSCHEME}}"

    if ! is_supported_colorscheme "$colorscheme"; then
        warn "Unknown colorscheme '${colorscheme}', defaulting to ${DEFAULT_COLORSCHEME}"
        colorscheme="$DEFAULT_COLORSCHEME"
    fi

    printf "%s" "$colorscheme"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo
    load_profile

    COLORSCHEME="$(resolve_colorscheme "${1:-}")"

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
    elif is_arch_linux; then
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

main "$@"
