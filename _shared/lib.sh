#!/bin/bash

# shellcheck source=/dev/null

# Shared library for colorscheme installation
# Provides DRY functions for wallpaper, bat, fish, and starship setup

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Get the absolute path to the _shared directory
readonly SHARED_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

set_wallpaper() {
    local theme="$1"
    local wallpaper_name="$2"
    local wallpaper_path="${SHARED_DIR}/wallpapers/${theme}/${wallpaper_name}"
    
    if ! [ -f "$wallpaper_path" ]; then
        warn "Wallpaper not found: $wallpaper_path"
        return 1
    fi
    
    if is_macos && cmd_exists "wallpaper"; then
        action "Setting wallpaper: ${wallpaper_name}"
        wallpaper set "$wallpaper_path"
    elif is_arch && cmd_exists "feh"; then
        action "Setting wallpaper: ${wallpaper_name}"
        feh --bg-scale "$wallpaper_path"
    elif is_debian && cmd_exists "gsettings"; then
        action "Setting wallpaper: ${wallpaper_name}"
        gsettings set org.gnome.desktop.background picture-uri "file://${wallpaper_path}"
        gsettings set org.gnome.desktop.background picture-uri-dark "file://${wallpaper_path}"
    else
        warn "No supported wallpaper command found"
        return 1
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_bat_theme() {
    local theme_repo="$1"
    local theme_name="$2"
    
    if ! cmd_exists "bat"; then
        return 0
    fi
    
    action "Installing bat theme: ${theme_name}"
    
    local bat_themes_dir="$(bat --config-dir)/themes"
    mkdir -p "$bat_themes_dir"
    
    local temp_dir="${HOME}/.config/bat/${theme_name}"
    
    # Clone or update the theme repository
    if [ -d "$temp_dir" ]; then
        git -C "$temp_dir" pull
    else
        git clone "$theme_repo" "$temp_dir"
    fi
    
    # Copy theme files
    cp "${temp_dir}"/*.tmTheme "$bat_themes_dir" 2>/dev/null || true
    
    # Rebuild cache
    bat cache --build
    
    success "Bat theme installed: ${theme_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_fish_theme() {
    local plugin="$1"
    local theme_name="$2"
    
    if ! cmd_exists "fish"; then
        return 0
    fi
    
    action "Installing fish theme: ${theme_name}"
    
    # Install fisher plugin
    fish -c "fisher install ${plugin}" 2>/dev/null || true
    
    # Apply theme
    fish -c "fish_config theme save \"${theme_name}\"" 2>/dev/null || true
    
    success "Fish theme installed: ${theme_name}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_starship_config() {
    local theme="$1"
    
    if ! cmd_exists "starship"; then
        return 0
    fi
    
    local config_path="${SHARED_DIR}/configs/starship/${theme}.toml"
    
    if ! [ -f "$config_path" ]; then
        warn "Starship config not found: $config_path"
        return 1
    fi
    
    action "Installing starship config: ${theme}"
    
    mkdir -p ~/.config
    cp "$config_path" ~/.config/starship.toml
    
    success "Starship config installed: ${theme}"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_lazygit_theme() {
    local theme_name="$1"
    local theme_source="$2"  # 'repo' for git repos, 'local' for our custom themes
    local theme_arg="$3"      # repo URL or config filename
    
    if ! cmd_exists "lazygit"; then
        return 0
    fi
    
    action "Installing lazygit theme: ${theme_name}"
    
    local lazygit_config_dir="$(lazygit --config-dir 2>/dev/null || echo "$HOME/.config/lazygit")"
    mkdir -p "${lazygit_config_dir}"
    
    if [ "$theme_source" = "repo" ]; then
        # Clone or update the theme repository (for catppuccin)
        local theme_dir="${lazygit_config_dir}/${theme_name}"
        
        if [ -d "$theme_dir" ]; then
            git -C "$theme_dir" pull 2>/dev/null || true
        else
            git clone "$theme_arg" "$theme_dir" 2>/dev/null || return 0
        fi
    elif [ "$theme_source" = "local" ]; then
        # Copy our custom theme file
        local source_theme="${SHARED_DIR}/configs/lazygit/${theme_arg}"
        
        if [ -f "$source_theme" ]; then
            cp "$source_theme" "${lazygit_config_dir}/${theme_arg}"
            success "Lazygit theme installed: ${theme_name}"
        else
            warn "Lazygit theme file not found: ${source_theme}"
            return 1
        fi
    fi
}
