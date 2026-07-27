#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

main() {
    action "Setting up Rose Pine theme (macOS)"
    bash ../universal/rose-pine.sh
    success "Rose Pine theme setup complete (macOS)"
}

main
