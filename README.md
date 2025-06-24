# macOS Dotfiles

This repository contains my macOS configuration files, designed to replicate an Arch Linux sway/waybar workflow using native macOS tools.

## Quick Start

### Setting Up External Keyboards

When using an external keyboard, you'll need to configure Karabiner-Elements to map the Win key correctly:

1. Open Karabiner-Elements
2. Go to the **Devices** tab
3. Select your keyboard from the dropdown
4. Add these Simple Modifications:
   - `left_command` → `left_option` (Win key becomes Option)
   - `left_control` → `left_command` (Ctrl key becomes Command)
   - `left_option` → `left_control` (Alt key becomes Control)

This ensures:
- **Win+D** opens Spotlight (instead of Alt+D)
- **Win+Return** opens Ghostty terminal
- **Win+B** opens browser
- All other Win+key shortcuts work as expected

### Setting Up External Mice

For mice with inverted scroll direction:

1. Open Karabiner-Elements
2. Go to the **Devices** tab
3. Select your mouse from the dropdown
4. Enable "Flip mouse vertical wheel"

This reverses the scroll direction to match natural scrolling preferences.

### Key Components

- **Sketchybar**: Custom status bar (waybar replacement)
- **Aerospace**: Tiling window manager (sway replacement)
- **Karabiner-Elements**: Keyboard customization
- **Ghostty**: Terminal emulator

### Keyboard Shortcuts

All shortcuts use the Win key (Option after remapping) as the modifier:

- `Win+Return` - Open terminal (Ghostty)
- `Win+B` - Open browser
- `Win+Shift+B` - Open private browser window
- `Win+D` - Open Spotlight search
- `Win+Q` - Close window
- `Win+Shift+Q` - Quit application
- `Win+C` - Clipboard history
- `Win+Y` - Screenshot to clipboard
- `Win+Shift+Y` - Area screenshot

### Text Navigation (Linux-style)

- `Ctrl+Left/Right` - Move by word
- `Ctrl+Shift+Left/Right` - Select by word
- `Ctrl+Backspace` - Delete word backward
- `Ctrl+Delete` - Delete word forward

### Terminal Copy/Paste

In terminal applications, copy/paste works like Linux:
- `Ctrl+Shift+C` - Copy
- `Ctrl+Shift+V` - Paste

### Troubleshooting

See individual component documentation:
- Karabiner configuration: `karabiner/KARABINER_CONFIG_NOTE.md`
- Temporary fixes: `TEMPORARY_FIXES.md`
- Development notes: `CLAUDE.md`

## Repository Structure

```
.config/
├── karabiner/          # Keyboard customization
├── sketchybar/         # Status bar configuration
├── aerospace/          # Window manager
├── nvim/              # Neovim configuration
├── ghostty/           # Terminal configuration
└── ...
```

For detailed information about each component, see `CLAUDE.md`.