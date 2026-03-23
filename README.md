# 'colorscheme' Module 🎨

[![Tests](https://github.com/dotbrains/colorschemes/actions/workflows/tests.yml/badge.svg)](https://github.com/dotbrains/colorschemes/actions/workflows/tests.yml)
[![Lint](https://github.com/dotbrains/colorschemes/actions/workflows/lint.yml/badge.svg)](https://github.com/dotbrains/colorschemes/actions/workflows/lint.yml)
[![License: PolyForm Shield 1.0.0](https://img.shields.io/badge/License-PolyForm%20Shield%201.0.0-blue.svg)](https://polyformproject.org/licenses/shield/1.0.0/)

Multi-OS colorscheme configuration with clear separation between operating systems while maintaining DRY principles.

## Structure

```text
colorschemes/
├── _shared/              # Shared resources (DRY)
│   ├── lib.sh           # Common functions for all OSes
│   ├── wallpapers/      # Theme wallpapers
│   │   ├── gruvbox/
│   │   ├── nord/
│   │   └── catppuccin/
│   └── configs/         # Shared configurations
│       └── starship/    # Starship prompt configs
├── macos/               # macOS-specific scripts
│   ├── gruvbox.sh
│   ├── nord.sh
│   ├── catppuccin.sh
│   └── terminal/        # Terminal.app themes
│       ├── apply_theme.applescript
│       └── themes/
├── arch/                # Arch Linux-specific scripts
│   ├── gruvbox.sh
│   ├── nord.sh
│   └── catppuccin.sh
├── universal/           # Cross-platform scripts
│   ├── gruvbox.sh      # fish, bat, starship
│   ├── nord.sh
│   └── catppuccin.sh
└── colorschemes.sh     # Entry point with OS detection
```

## Supported Themes

- **Gruvbox**: Retro groove color scheme
- **Nord**: Arctic, north-bluish color palette
- **Catppuccin**: Soothing pastel theme

## Supported Applications

### Universal (All OSes)

- Fish shell
- Bat (syntax highlighter)
- Starship (prompt)
- Lazygit (git TUI) - All themes supported

### macOS

- Terminal.app
- Desktop wallpaper

### Arch Linux

- Desktop wallpaper (via feh)

### Debian/Ubuntu

- GNOME Terminal
- Desktop wallpaper

## Usage

### Lazygit Theme Configuration

After running the colorscheme setup, lazygit themes are installed but need to be activated. Add this to your shell configuration:

**Gruvbox:**

```bash
alias lazygit='lazygit --use-config-file="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/gruvbox.yml"'
```

**Nord:**

```bash
alias lazygit='lazygit --use-config-file="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/nord.yml"'
```

**Catppuccin:**

```bash
alias lazygit='lazygit --use-config-file="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/catppuccin/macchiato-blue.yml"'
```

Or set the environment variable:

```bash
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml,$HOME/.config/lazygit/gruvbox.yml"
```

### Quick Start

Edit `colorschemes.sh` and set your preferred theme:

```bash
COLORSCHEME="gruvbox"  # Options: gruvbox, nord, catppuccin
```

Then run:

```bash
bash colorschemes.sh
```

### OS-Specific Usage

**macOS only:**

```bash
bash macos/gruvbox.sh
```

**Universal (cross-platform) only:**

```bash
bash universal/gruvbox.sh
```

## How It Works

### Entry Point Flow

1. `colorschemes.sh` detects your OS
2. Routes to appropriate OS-specific script (`macos/`, `arch/`, `debian/`, etc.)
3. OS-specific script:
   - Applies OS-specific configurations (wallpaper, Terminal themes)
   - Calls universal script for cross-platform tools
4. Universal script configures fish, bat, starship, etc.

### DRY Principles

All shared functionality lives in `_shared/lib.sh`:

- `set_wallpaper()` - Abstracts wallpaper setting across OSes
- `install_fish_theme()` - Installs fish shell themes
- `install_bat_theme()` - Installs bat syntax themes
- `install_starship_config()` - Applies starship configurations
- `install_lazygit_theme()` - Installs lazygit themes (supports both git repos and local configs)

### Adding New Themes

1. Add wallpapers to `_shared/wallpapers/<theme>/`
2. Add starship config to `_shared/configs/starship/<theme>.toml`
3. Create `universal/<theme>.sh` for cross-platform setup
4. Create OS-specific scripts:
   - `macos/<theme>.sh` for macOS
   - `arch/<theme>.sh` for Arch Linux
   - `debian/<theme>.sh` for Debian/Ubuntu
5. Add Terminal.app theme to `macos/terminal/themes/<Theme>.terminal` (macOS only)

### Adding New OS Support

1. Create new directory: `debian/`, `fedora/`, etc.
2. Create OS-specific scripts for each theme: `debian/gruvbox.sh`, `debian/nord.sh`, etc.
3. Update `colorschemes.sh` with OS detection logic using utilities functions (e.g., `is_debian`, `is_arch_linux`)
4. Implement OS-specific functions in `_shared/lib.sh` (e.g., wallpaper setting)

## Benefits

✅ **Clear OS separation**: Easy to see what works where

✅ **DRY code**: No duplication between themes

✅ **Composable**: OS scripts call universal scripts

✅ **Extensible**: Easy to add new OSes or themes

✅ **Maintainable**: Shared resources in one place
