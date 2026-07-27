#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

main() {
    action "Setting up Dracula theme (Arch Linux)"
    bash ../universal/dracula.sh
    success "Dracula theme setup complete (Arch Linux)"
}

main
