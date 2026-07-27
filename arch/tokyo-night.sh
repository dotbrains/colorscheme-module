#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

main() {
    action "Setting up Tokyo Night theme (Arch Linux)"
    bash ../universal/tokyo-night.sh
    success "Tokyo Night theme setup complete (Arch Linux)"
}

main
