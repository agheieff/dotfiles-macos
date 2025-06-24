# Karabiner Configuration Note
Date: 2025-06-24

## Current Working Configuration

This documents the current working Karabiner configuration after resolving modifier key issues that occurred when macOS keyboard setup reset the mappings.

## Important: Key Naming Convention

When referring to keyboard shortcuts:
- **Ctrl** = Physical Ctrl key on external keyboard = Fn key on MacBook keyboard
- **Win** = Physical Win key on external keyboard = Option key on MacBook keyboard  
- **Alt** = Physical Alt key on external keyboard = Command key on MacBook keyboard

These names refer to the PHYSICAL keys pressed, not the internal macOS modifiers after remapping.

### Key Mappings Overview

All shortcuts in complex_modifications use `left_option` as the trigger modifier. To make this work correctly on different keyboards, we use device-specific simple_modifications.

### Built-in Keyboard (All Keyboards)
- Fn key → Command
- Left Control → Command (same as Fn key)
- Left Command → Control

This allows the built-in Option key to work naturally for all shortcuts, and provides two ways to access Command (both Fn and Control keys).

### External Keyboards

#### SEMICO USB Gaming Keyboard
Vendor ID: 6700, Product ID: 31876

#### Generic External Keyboard
Vendor ID: 39658, Product ID: 4137

Both external keyboards use the same mapping:
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

## Text Navigation Fix (2025-06-24)

The Linux-style text navigation (Ctrl+Arrow for word movement) was not working because:
1. The rules were using the `control` modifier (which maps to different physical keys)
2. We needed to use `command` modifier instead to match the physical Ctrl key on external keyboards

Fixed by changing all text navigation rules from `control` to `command` modifier, so:
- External keyboard: Physical Ctrl + Arrow = Word navigation
- Built-in keyboard: Fn + Arrow = Word navigation

## Adding a New External Keyboard

When connecting a new external keyboard:

1. Open Karabiner-Elements
2. Go to the "Devices" tab
3. Select your new keyboard from the dropdown
4. Add these Simple Modifications:
   - From: left_command → To: left_option
   - From: left_control → To: left_command
   - From: left_option → To: left_control
5. The keyboard will automatically be saved to karabiner.json with its vendor/product IDs

This ensures the physical Win key on your external keyboard triggers all shortcuts.

## Mouse Configuration

External mice can have their scroll direction flipped in Karabiner:

1. Go to Devices tab → Select your mouse
2. Enable "Flip mouse vertical wheel"

Currently configured mice with flipped scroll:
- Logitech mouse (Vendor ID: 1133, Product ID: 45082)
- Logitech mouse (Vendor ID: 1133, Product ID: 49271)
- Bluetooth mouse (Device Address: 34-ec-b6-7c-54-50)