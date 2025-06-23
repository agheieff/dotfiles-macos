#!/bin/bash

# Get the directory paths
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$PLUGIN_DIR")"

# Source colors
source "$CONFIG_DIR/colors.sh"

APP_NAME="$1"

# Remove existing menu items
sketchybar --remove '/menu\..*/'

# Common menu items for most apps
MENUS=("File" "Edit" "View" "Window" "Help")

# Add app-specific menus
case "$APP_NAME" in
  "Safari"|"Google Chrome"|"Firefox")
    MENUS=("File" "Edit" "View" "History" "Bookmarks" "Window" "Help")
    ;;
  "Code")
    MENUS=("File" "Edit" "Selection" "View" "Go" "Run" "Terminal" "Help")
    ;;
  "Terminal"|"iTerm2"|"Ghostty")
    MENUS=("Shell" "Edit" "View" "Window" "Help")
    ;;
  "Finder")
    MENUS=("File" "Edit" "View" "Go" "Window" "Help")
    ;;
esac

# First add the app name
sketchybar --add item menu.app left \
  --set menu.app label="$APP_NAME" \
                 label.color=$BLACK \
                 label.font="SF Pro:Bold:17.0" \
                 label.padding_left=8 \
                 label.padding_right=8 \
                 background.color=$YELLOW \
                 background.corner_radius=5 \
                 background.height=26 \
                 icon.drawing=off

# Add separator
sketchybar --add item menu.separator left \
  --set menu.separator label="|" \
                      label.color=$GREY \
                      label.padding_left=3 \
                      label.padding_right=3 \
                      background.drawing=off

# Add menu items to bar
position=1
for menu in "${MENUS[@]}"; do
  sketchybar --add item menu.$position left \
    --set menu.$position label="$menu" \
                         label.color=$WHITE \
                         label.padding_left=8 \
                         label.padding_right=8 \
                         label.font="SF Pro:Regular:17.0" \
                         background.color=$BACKGROUND_1 \
                         background.corner_radius=5 \
                         background.height=26 \
                         click_script="$PLUGIN_DIR/click_menu.sh '$menu'"
  ((position++))
done