#!/bin/bash

# Get the directory paths
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$PLUGIN_DIR")"

# Source colors
source "$CONFIG_DIR/colors.sh"

# Function to get icon for an app
get_app_icon() {
  local app=$1
  case "$app" in
    "Safari") echo "󰖟" ;;
    "Google Chrome"|"Chrome") echo "󰊯" ;;
    "Firefox"|"Firefox Developer Edition") echo "󰈹" ;;
    "Terminal"|"iTerm2"|"Ghostty") echo "󰆍" ;;
    "Code"|"Visual Studio Code") echo "󰨞" ;;
    "Slack") echo "󰒱" ;;
    "Discord") echo "󰙯" ;;
    "Spotify") echo "󰓇" ;;
    "Mail") echo "󰊫" ;;
    "Messages") echo "󰍩" ;;
    "Finder") echo "󰀶" ;;
    "Microsoft Teams"|"Teams") echo "󰊻" ;;
    "Microsoft Outlook"|"Outlook") echo "󰴢" ;;
    *) echo "󰘔" ;;
  esac
}

# Get current state
CURRENT=$(aerospace list-workspaces --focused)
WORKSPACES=$(aerospace list-workspaces --monitor all --empty no | sort -g)

# Always include current
echo "$WORKSPACES" | grep -q "^$CURRENT$" || WORKSPACES=$(echo -e "$CURRENT\n$WORKSPACES" | sort -g | uniq)

# Get existing spaces in bar
EXISTING=$(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))' | sed 's/space\.//')

# Remove spaces that shouldn't exist
for space in $EXISTING; do
  if ! echo "$WORKSPACES" | grep -q "^$space$"; then
    sketchybar --remove space.$space
  fi
done

# Update or create each workspace
for ws in $WORKSPACES; do
  # Get apps for this workspace
  apps=$(aerospace list-windows --workspace $ws --format "%{app-name}" 2>/dev/null | sort -u)
  
  # Build icon string
  icon="$ws"
  if [ -n "$apps" ]; then
    icon="${icon}  "
    first=true
    while IFS= read -r app; do
      [ -z "$app" ] && continue
      app_icon=$(get_app_icon "$app")
      if $first; then
        icon="${icon}${app_icon}"
        first=false
      else
        icon="${icon}   ${app_icon}"
      fi
    done <<< "$apps"
  fi
  
  # Set colors
  if [ "$ws" = "$CURRENT" ]; then
    bg_drawing=on
    text_color=$BLACK
    bg_color=$YELLOW
  else
    bg_drawing=off
    text_color=$WHITE
    bg_color=$BACKGROUND_1
  fi
  
  # Update or create
  if sketchybar --query space.$ws &>/dev/null; then
    sketchybar --set space.$ws \
      icon="$icon" \
      icon.color=$text_color \
      background.color=$bg_color \
      background.drawing=$bg_drawing
  else
    # Find position for new space
    position="left"
    for existing in $(echo "$EXISTING" | sort -g); do
      if [ "$existing" -lt "$ws" ] 2>/dev/null; then
        position="space.$existing"
      fi
    done
    
    # Create new space
    if [ "$position" = "left" ]; then
      sketchybar --add item space.$ws left
    else
      sketchybar --add item space.$ws left \
        --move space.$ws after $position
    fi
    
    sketchybar --set space.$ws \
      background.color=$bg_color \
      background.corner_radius=5 \
      background.height=26 \
      background.drawing=$bg_drawing \
      icon="$icon" \
      icon.color=$text_color \
      icon.padding_left=7 \
      icon.padding_right=7 \
      icon.font="SF Pro:Bold:18.0" \
      label.drawing=off \
      click_script="aerospace workspace $ws"
      
    # Update existing list
    EXISTING="$EXISTING $ws"
  fi
done