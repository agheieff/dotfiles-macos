# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a macOS configuration repository (dotfiles-macos) containing dotfiles for various applications, primarily focused on replicating an Arch Linux sway/waybar workflow using native macOS tools.

## Key Components

### Sketchybar
- **Location**: `.config/sketchybar/`
- **Purpose**: Custom status bar (waybar replacement)
- **Structure**:
  - `sketchybarrc`: Main configuration entry point
  - `items/`: Individual bar components (spaces, clock, battery, etc.)
  - `plugins/`: Shell scripts that update bar items
  - `colors.sh` & `icons.sh`: Shared visual configuration
- **Restart after changes**: `brew services restart sketchybar`

### Aerospace
- **Location**: `.config/aerospace/` (if present)
- **Purpose**: Tiling window manager (sway replacement)
- **Key**: Configured to use Win (Option) key as modifier with Colemak WASD navigation

### Karabiner-Elements
- **Location**: `.config/karabiner/karabiner.json`
- **Purpose**: Keyboard remapping for custom shortcuts and modifier key handling
- **Structure**: Complex JSON with rules for key remapping and application-specific modifications
- **Key Configuration**:
  - All complex modifications use `left_option` as the trigger modifier
  - Device-specific simple modifications handle keyboard differences:
    - Built-in keyboard: Option key works naturally for shortcuts
    - External keyboards (e.g., SEMICO USB Gaming Keyboard): Physical Win key mapped to Option
  - See `karabiner/KARABINER_CONFIG_NOTE.md` for detailed configuration

### Neovim
- **Location**: `.config/nvim/init.lua`
- **Purpose**: Text editor configuration
- **Note**: Uses Colemak movement keys (w=up, a=left, r=down, s=right)

### Helper Scripts
- **C Programs**: `.config/sketchybar.backup/helpers/` contains C programs for CPU and network monitoring
- **Build**: Use `make` in the helpers directory to compile

## Common Development Tasks

### Modifying Sketchybar
1. Edit relevant files in `items/` or `plugins/`
2. Test changes: `sketchybar --reload`
3. Check logs if issues: `tail -f /tmp/sketchybar_*.out`

### Updating Karabiner Rules
1. For device-specific modifications: Use Karabiner-Elements GUI → Devices tab
2. For complex modifications: Edit `karabiner.json` carefully (it's sensitive to JSON syntax)
3. Changes apply automatically when saved
4. Test in Karabiner EventViewer before committing
5. Note: Simple modifications in the main GUI are global; device-specific ones are in Devices tab

### Working with Shell Scripts
- All Sketchybar plugins are bash scripts
- Use `#!/bin/bash` shebang
- Scripts should be executable: `chmod +x script.sh`

## Architecture Notes

### Sketchybar Event System
- Items subscribe to events (e.g., `system_woke`, `volume_change`)
- Plugins are triggered by events to update item appearance
- Communication via `sketchybar --set` commands

### Workspace Management
- Aerospace handles window tiling and workspace switching
- Sketchybar displays workspace indicators with app icons
- Integration through shell commands and event subscriptions

### System Integration
- Uses macOS native commands: `pmset`, `diskutil`, `networksetup`
- Relies on SF Symbols for icons
- Requires specific fonts (SF Pro, Hack Nerd Font)

## Repository Information
- **GitHub**: `agheieff/dotfiles-macos`
- **Branch**: master

## Known Issues
- Win+Ctrl combinations may input characters (see TODO.md)
- Some features from original Arch setup pending implementation