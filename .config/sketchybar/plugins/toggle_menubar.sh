#!/bin/bash

# Get the directory paths
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$PLUGIN_DIR")"

# Source colors
source "$CONFIG_DIR/colors.sh"

# Check current state by querying if spaces are visible
SPACE_VISIBLE=$(sketchybar --query space.1 | jq -r '.geometry.drawing')

if [ "$SPACE_VISIBLE" = "on" ] || [ "$SPACE_VISIBLE" = "true" ]; then
  # Hide workspaces, show menu bar
  
  # Hide all space items
  sketchybar --set '/space\..*/' drawing=off
  sketchybar --set spaces_bracket drawing=off
  sketchybar --set space_separator drawing=off
  
  # Update toggle icon
  sketchybar --set menubar_toggle icon="󰍉" icon.font="Hack Nerd Font:Regular:17.0" icon.color=$YELLOW
  
  # Get current app name and show menu items
  APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')
  
  # Create menu items based on the app
  "$PLUGIN_DIR/show_app_menus.sh" "$APP_NAME"
  
else
  # Show workspaces, hide menu bar
  
  # Show all space items
  sketchybar --set '/space\..*/' drawing=on
  sketchybar --set spaces_bracket drawing=on
  sketchybar --set space_separator drawing=on
  
  # Update toggle icon
  sketchybar --set menubar_toggle icon="󰍜" icon.font="Hack Nerd Font:Regular:17.0" icon.color=$GREY
  
  # Remove menu items
  sketchybar --remove '/menu\..*/'
  
  # Refresh spaces
  "$PLUGIN_DIR/spaces.sh"
fi