# macOS Dotfiles

This repository contains my macOS configuration files, replicating my Arch Linux sway/waybar setup using native macOS tools.

## Components

- **Sketchybar**: Custom status bar (waybar replacement)
- **Aerospace**: Tiling window manager (sway replacement)
- **Karabiner-Elements**: Keyboard remapping for Colemak layout support

## Installation

1. Install required tools:
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install sketchybar
brew install --cask aerospace
brew install --cask karabiner-elements
brew install jq
brew install bc

# Install Hack Nerd Font
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```

2. Clone this repository:
```bash
git clone https://github.com/agheieff/dotfiles-macos.git
cd dotfiles-macos
```

3. Create symlinks:
```bash
# Backup existing configs if any
mv ~/.config/sketchybar ~/.config/sketchybar.backup 2>/dev/null
mv ~/.config/aerospace ~/.config/aerospace.backup 2>/dev/null
mv ~/.config/karabiner ~/.config/karabiner.backup 2>/dev/null

# Create symlinks
ln -s $(pwd)/.config/sketchybar ~/.config/sketchybar
ln -s $(pwd)/.config/aerospace ~/.config/aerospace
ln -s $(pwd)/.config/karabiner ~/.config/karabiner
```

4. Start services:
```bash
# Start Sketchybar
brew services start sketchybar

# Aerospace starts automatically
# Karabiner starts automatically
```

## Features

### Sketchybar
- Dynamic workspaces with app icons
- System stats (CPU, memory, disk, network)
- Volume and brightness indicators
- Battery status
- Clock with notch-aware positioning
- Toggle between workspace view and native menu bar

### Aerospace
- Tiling window management
- Colemak-compatible WASD navigation
- Workspace management (Win+1-9)
- Window movement and resizing
- Multiple layout modes

### Karabiner
- Win (Option) key as modifier
- Application shortcuts (Win+Return for terminal, Win+B for browser)
- Media controls with Colemak mapping
- Screenshot shortcuts
- Spotlight remapped to Win+D

## Keyboard Shortcuts

### Window Management
- `Win+W/A/S/D`: Focus window in direction
- `Win+Shift+W/A/S/D`: Move window in direction
- `Win+Ctrl+W/A/S/D`: Move window to workspace in direction
- `Win+1-9`: Switch to workspace
- `Win+Shift+1-9`: Move window to workspace
- `Win+Space`: Toggle floating
- `Win+F`: Toggle fullscreen

### Applications
- `Win+Return`: Open Ghostty terminal
- `Win+B`: Open browser (Firefox)
- `Win+D`: Spotlight search

### Media Controls (Colemak positions)
- `Win+U`: Volume up
- `Win+E`: Volume down
- `Win+O`: Volume mute
- `Win+Y`: Brightness down
- `Win+I`: Brightness up
- `Win+P`: Play/pause

### Screenshots
- `Shift+Win+4`: Area screenshot
- `Shift+Win+3`: Full screenshot

## Known Issues

See [TODO.md](TODO.md) for pending features and known issues.

## Credits

Based on my [Arch Linux dotfiles](https://github.com/agheieff/dotfiles) sway/waybar configuration.