# Karabiner Configuration Note
Date: 2025-06-24

## Current Working Configuration

This documents the current working Karabiner configuration after resolving modifier key issues that occurred when macOS keyboard setup reset the mappings.

### Key Mappings Overview

All shortcuts in complex_modifications use `left_option` as the trigger modifier. To make this work correctly on different keyboards, we use device-specific simple_modifications.

### Built-in Keyboard (All Keyboards)
- Fn key → Command
- Left Control → Disabled (vk_none)
- Left Command → Control

This allows the built-in Option key to work naturally for all shortcuts.

### External Keyboard (SEMICO USB Gaming Keyboard)
Vendor ID: 6700, Product ID: 31876

- Physical Win key (left_command) → Option (triggers shortcuts)
- Physical Ctrl key → Command
- Physical Alt key (left_option) → Control

This configuration ensures:
- Win+D opens Spotlight on external keyboard
- Option+D opens Spotlight on built-in keyboard
- All other Win+[key] shortcuts work correctly on external keyboard
- All Option+[key] shortcuts work correctly on built-in keyboard

### Important Notes
1. Device-specific simple modifications are configured in Karabiner GUI under Devices tab
2. The complex modifications remain unchanged - they all use left_option as the modifier
3. This setup survives macOS keyboard detection dialogs