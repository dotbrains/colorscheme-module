#!/bin/bash

# shellcheck source=/dev/null

# Universal Catppuccin colorscheme setup
# Configures cross-platform tools: fish, bat, starship, lazygit

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

# Load shared functions
source "../_shared/lib.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    action "Setting up Catppuccin theme (universal)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Fish shell theme
    install_fish_theme "catppuccin/fish" "Catppuccin Macchiato"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Bat theme
    install_bat_theme "https://github.com/catppuccin/bat" "catppuccin"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Lazygit theme
    install_lazygit_theme "catppuccin" "repo" "https://github.com/catppuccin/lazygit"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Starship prompt
    install_starship_config "catppuccin"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    success "Catppuccin theme setup complete (universal)"

}

main
