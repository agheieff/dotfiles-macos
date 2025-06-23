#!/bin/bash

# Get the directory paths
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$PLUGIN_DIR")"

# Source colors
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# Try different methods to get brightness
BRIGHTNESS=""

# Method 1: Using ioreg (most reliable on macOS)
if [ -z "$BRIGHTNESS" ]; then
    BRIGHTNESS=$(ioreg -c AppleBacklightDisplay | grep brightness | grep -v "max-brightness" | tail -1 | awk '{print int($4/10.24)}' 2>/dev/null)
fi

# Method 2: Using brightness command if installed
if [ -z "$BRIGHTNESS" ] && command -v brightness &> /dev/null; then
    BRIGHTNESS=$(brightness -l | grep 'display 0:' | sed 's/.*brightness \([0-9.]*\)/\1/' | awk '{print int($1 * 100)}' 2>/dev/null)
fi

# Method 3: Using osascript
if [ -z "$BRIGHTNESS" ]; then
    BRIGHTNESS=$(osascript -e 'tell application "System Events" to get brightness of display 1' 2>/dev/null | awk '{print int($1 * 100)}')
fi

# Method 4: Check for external displays
if [ -z "$BRIGHTNESS" ]; then
    BRIGHTNESS=$(ioreg -c IODisplayConnect | grep brightness | tail -1 | awk '{print int($4/10.24)}' 2>/dev/null)
fi

# Default if all methods fail or no internal display
if [ -z "$BRIGHTNESS" ] || [ "$BRIGHTNESS" = "0" ]; then
    # Check if this is a desktop Mac or external display only
    INTERNAL_DISPLAY=$(system_profiler SPDisplaysDataType | grep -c "Built-in" 2>/dev/null || echo "0")
    if [ "$INTERNAL_DISPLAY" = "0" ]; then
        # No internal display, hide the brightness indicator
        sketchybar --set $NAME drawing=off
        exit 0
    fi
    BRIGHTNESS="--"
fi

# Set appropriate icon based on brightness level
if [ "$BRIGHTNESS" = "--" ]; then
    ICON=󰃠
elif [ "$BRIGHTNESS" -ge 75 ]; then
    ICON=󰃠
elif [ "$BRIGHTNESS" -ge 50 ]; then
    ICON=󰃟
elif [ "$BRIGHTNESS" -ge 25 ]; then
    ICON=󰃞
else
    ICON=󰃞
fi

if [ "$BRIGHTNESS" != "--" ]; then
    sketchybar --set $NAME icon="$ICON" label="${BRIGHTNESS}%" drawing=on
else
    sketchybar --set $NAME icon="$ICON" label="${BRIGHTNESS}%" drawing=on
fi