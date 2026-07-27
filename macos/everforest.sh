#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

main() {
    action "Setting up Everforest theme (macOS)"
    bash ../universal/everforest.sh
    success "Everforest theme setup complete (macOS)"
}

main
