# Colemak Keyboard Layout Changes for Aerospace and Karabiner

This document summarizes the changes made to support Colemak keyboard layout in the configuration files.

## Key Principle
On macOS, Aerospace and Karabiner see the **physical key positions**, not the Colemak letters. So we need to map to the physical keys that produce the desired letters in Colemak.

## Aerospace.toml Changes

### Navigation Keys (WARS pattern in Colemak)
- **W** → W physical key (same)
- **A** → A physical key (same)  
- **R** → S physical key (for down movement)
- **S** → D physical key (for right movement)

### Other Key Changes
- **alt-t** (floating toggle) → **alt-f** (T in Colemak is F physical)
- **alt-f** (fullscreen) → **alt-t** (F in Colemak is T physical)
- **alt-e** (layout toggle) → **alt-k** (E in Colemak is K physical)

### Updated Bindings
1. Focus navigation: `alt-w/a/r/s` (WARS in Colemak)
2. Move window: `alt-shift-w/a/r/s`
3. Move to workspace and follow: `alt-ctrl-w/a/r/s`
4. Resize mode: `w/a/r/s` keys

## Karabiner.json Changes

### Media Controls
- **Win+I** (volume up) → **Win+L** (I in Colemak is L physical)
- **Win+Shift+I** (volume down) → **Win+Shift+L**
- **Win+U** (mute) → **Win+U** (same physical key)
- **Win+J** (play/pause) → **Win+Y** (J in Colemak is Y physical)
- **Win+K** (next track) → **Win+E** (K in Colemak is E physical)
- **Win+Shift+K** (previous) → **Win+Shift+E**
- **Win+O** (brightness up) → **Win+;** (O in Colemak is semicolon physical)
- **Win+Shift+O** (brightness down) → **Win+Shift+;**

### Screenshot Controls
- All **Win+Y** shortcuts now use Y physical key (not O as before)

### Other Shortcuts
- **Win+D** (Spotlight) → **Win+G** (D in Colemak is G physical)

## Testing
After these changes, test each keybinding to ensure they work as expected with your Colemak layout enabled in macOS System Settings.