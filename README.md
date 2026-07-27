# 'colorscheme' Module 🎨

[![Tests](https://github.com/dotbrains/colorscheme-module/actions/workflows/tests.yml/badge.svg)](https://github.com/dotbrains/colorscheme-module/actions/workflows/tests.yml)
[![Lint](https://github.com/dotbrains/colorscheme-module/actions/workflows/lint.yml/badge.svg)](https://github.com/dotbrains/colorscheme-module/actions/workflows/lint.yml)
[![License: PolyForm Shield 1.0.0](https://img.shields.io/badge/License-PolyForm%20Shield%201.0.0-blue.svg)](https://polyformproject.org/licenses/shield/1.0.0)

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
├── themes/              # Theme manifests used by smu and contract checks
├── scripts/             # Theme registry tooling
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
- **Tokyo Night**: Dark blue editor-oriented palette
- **Rose Pine**: Low-contrast rosy pine palette
- **Dracula**: High-contrast purple and green palette
- **Everforest**: Green forest palette
- **Solarized**: Precision light/dark terminal palette
- **Kanagawa**: Japanese painting-inspired palette

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

Use `smu` to save and apply your preferred theme:

```bash
smu theme set nord --apply
```

Or run this module directly:

```bash
bash colorschemes.sh nord
```

Theme resolution order is:

1. Direct script argument, e.g. `bash colorschemes.sh catppuccin`
2. `SMU_THEME` environment variable
3. `~/.config/set-me-up/profile.env`
4. `gruvbox`

The saved set-me-up profile is shared with shell and app config repositories:

```bash
export SMU_THEME="gruvbox"
export SMU_PROMPT="starship"
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

1. `colorschemes.sh` resolves the selected theme
2. `colorschemes.sh` detects your OS
3. Routes to appropriate OS-specific script (`macos/`, `arch/`, `debian/`, etc.)
4. OS-specific script:
   - Applies OS-specific configurations (wallpaper, Terminal themes)
   - Calls universal script for cross-platform tools
5. Universal script configures fish, bat, starship, lazygit, Alacritty, etc.

### DRY Principles

All shared functionality lives in `_shared/lib.sh`:

- `set_wallpaper()` - Abstracts wallpaper setting across OSes
- `install_fish_theme()` - Installs fish shell themes
- `install_bat_theme()` - Installs bat syntax themes
- `install_starship_config()` - Applies starship configurations
- `install_lazygit_theme()` - Installs lazygit themes (supports both git repos and local configs)

### Adding New Themes

Theme metadata lives in `themes/<theme>.toml`. The manifest is the registry
entry that `smu theme list`, `smu theme doctor`, and repository contract checks
read, so add it first.

1. Add `themes/<theme>.toml`
2. Add wallpapers to `_shared/wallpapers/<theme>/`
3. Add starship config to `_shared/configs/starship/<theme>.toml`
4. Create `universal/<theme>.sh` for cross-platform setup
5. Create OS-specific scripts:
   - `macos/<theme>.sh` for macOS
   - `arch/<theme>.sh` for Arch Linux
   - `debian/<theme>.sh` for Debian/Ubuntu
6. Add Terminal.app theme to `macos/terminal/themes/<Theme>.terminal` (macOS only)
7. Add matching adapter files in the dotfile repositories referenced by the
   manifest, then run:

```bash
python3 scripts/theme_contract.py --local
python3 scripts/theme_contract.py
python3 scripts/generate-theme-adapters.py
python3 scripts/generate-theme-adapters.py <theme> --scaffold --aggregate
```

`theme_contract.py --local` validates files owned by this repository and is safe
for standalone CI. `theme_contract.py` also validates cross-repo adapter files in
an aggregate `set-me-up` checkout. `generate-theme-adapters.py` prints the
adapter inventory for each manifest so agents can see exactly where a theme
needs files before editing. Add `--scaffold` to create missing placeholder
adapters without overwriting existing files; add `--aggregate` to include
cross-repo shell, terminal, tmux, and editor adapters.

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

## Reproducible dev environment (Flox)

A [Flox](https://flox.dev) manifest at `.flox/env/manifest.toml` pins the
toolchain CI uses — `bash`, `shellcheck`, and `nodejs` (for
`npx markdownlint-cli2`). Activating it gives contributors the same versions on
macOS or Linux:

```bash
# From the colorschemes/ directory:
flox activate

# Inside the activated shell:
./tests/main.sh
npx markdownlint-cli2 "**/*.md"
```
