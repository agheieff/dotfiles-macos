#!/bin/bash

# Get the directory paths
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$PLUGIN_DIR")"

# Source colors
source "$CONFIG_DIR/colors.sh"

# If called from aerospace event, just update highlights
if [ "$SENDER" = "aerospace_workspace_change" ]; then
  CURRENT="${FOCUSED_WORKSPACE:-1}"
  # Quick highlight update
  sketchybar --set '/space\..*/' background.drawing=off icon.color=0xffcdd6f4
  sketchybar --set space.$CURRENT background.drawing=on icon.color=0xff181825 background.color=0xfff9e2af
  exit 0
fi

# Full update (called periodically)
# Get current workspace
CURRENT=$(aerospace list-workspaces --focused 2>/dev/null || echo "1")

# Simple icon map
get_icon() {
  case "$1" in
    "Firefox"|"Firefox Developer Edition") echo "󰈹" ;;
    "Ghostty"|"Terminal") echo "󰆍" ;;
    "Microsoft Outlook") echo "󰴢" ;;
    "Microsoft Teams") echo "󰊻" ;;
    "Finder") echo "󰀶" ;;
    *) echo "󰘔" ;;
  esac
}

# Get workspaces with windows
WORKSPACES=$(aerospace list-workspaces --monitor all --empty no 2>/dev/null | sort -g)
[ -z "$WORKSPACES" ] && WORKSPACES="1"

# Include current
echo "$WORKSPACES" | grep -q "^$CURRENT$" || WORKSPACES="$WORKSPACES
$CURRENT"
WORKSPACES=$(echo "$WORKSPACES" | sort -g | uniq)

# Update each workspace
for ws in $WORKSPACES; do
  # Get apps (with timeout)
  apps=$(timeout 1 aerospace list-windows --workspace $ws --format "%{app-name}" 2>/dev/null | sort -u)
  
  # Build icon
  icon="$ws"
  if [ -n "$apps" ]; then
    icon="$icon  "
    for app in $apps; do
      [ -n "$app" ] && icon="$icon$(get_icon "$app")   "
    done
  fi
  
  # Update or create
  if sketchybar --query space.$ws &>/dev/null; then
    if [ "$ws" = "$CURRENT" ]; then
      sketchybar --set space.$ws icon="$icon" background.drawing=on icon.color=0xff181825 background.color=0xfff9e2af
    else
      sketchybar --set space.$ws icon="$icon" background.drawing=off icon.color=0xffcdd6f4
    fi
  else
    sketchybar --add item space.$ws left \
      --set space.$ws \
        icon="$icon" \
        icon.font="SF Pro:Bold:18.0" \
        icon.padding_left=7 \
        icon.padding_right=7 \
        label.drawing=off \
        background.corner_radius=5 \
        background.height=26 \
        click_script="aerospace workspace $ws"
        
    if [ "$ws" = "$CURRENT" ]; then
      sketchybar --set space.$ws background.drawing=on icon.color=0xff181825 background.color=0xfff9e2af
    else
      sketchybar --set space.$ws background.drawing=off icon.color=0xffcdd6f4
    fi
  fi
done

# Clean up old workspaces
for item in $(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))' | sed 's/space\.//'); do
  if ! echo "$WORKSPACES" | grep -q "^$item$"; then
    sketchybar --remove space.$item
  fi
done