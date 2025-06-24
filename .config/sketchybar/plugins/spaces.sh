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
    "Zen Browser") echo "󰈹" ;; # Firefox-based
    "Terminal") echo "󰆍" ;;
    "iTerm2") echo "󰆍" ;;
    "Ghostty") echo "󰆍" ;;
    "Code"|"Visual Studio Code") echo "󰨞" ;;
    "Slack") echo "󰒱" ;;
    "Discord") echo "󰙯" ;;
    "Spotify") echo "󰓇" ;;
    "Mail") echo "󰊫" ;;
    "Messages") echo "󰍩" ;;
    "Finder") echo "󰀶" ;;
    "System Preferences"|"System Settings") echo "󰒓" ;;
    "Preview") echo "󰋩" ;;
    "Notes") echo "󰠮" ;;
    "Calendar") echo "󰃭" ;;
    "Music"|"Apple Music") echo "󰝚" ;;
    "Xcode") echo "󰀵" ;;
    # Microsoft Office apps
    "Microsoft Teams"|"Teams") echo "󰊻" ;;
    "Microsoft Outlook"|"Outlook") echo "󰴢" ;;
    "Microsoft Word"|"Word") echo "󰈙" ;;
    "Microsoft Excel"|"Excel") echo "󰈛" ;;
    "Microsoft PowerPoint"|"PowerPoint") echo "󰈧" ;;
    # LibreOffice
    "LibreOffice"|"LibreOffice Writer") echo "󰷈" ;;
    "LibreOffice Calc") echo "󰱾" ;;
    "LibreOffice Impress") echo "󰐩" ;;
    # AI/LLM apps
    "LM Studio") echo "󰧑" ;;
    "Cherry Studio") echo "󰚩" ;;
    # System utilities
    "Karabiner-Elements"|"Karabiner-EventViewer") echo "󰌌" ;;
    *) echo "󰘔" ;; # Default app icon
  esac
}

# Handle the aerospace_workspace_change event
if [ "$SENDER" = "aerospace_workspace_change" ]; then
  # Get the new focused workspace from the event or query it
  CURRENT_WORKSPACE="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
  
  # Check for empty workspaces and remove them (except current)
  items=$(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))')
  for item in $items; do
    workspace="${item#space.}"
    if [ "$workspace" != "$CURRENT_WORKSPACE" ]; then
      # Check if workspace has any windows
      apps=$(aerospace list-windows --workspace $workspace --format "%{app-name}" 2>/dev/null)
      if [ -z "$apps" ]; then
        sketchybar --remove space.$workspace
      fi
    fi
  done
  
  # Quick highlight update for existing workspaces
  if sketchybar --query space.$CURRENT_WORKSPACE &>/dev/null; then
    # Just update highlights, no need to rebuild
    items=$(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))')
    update_cmd=""
    for item in $items; do
      workspace="${item#space.}"
      if [ "$workspace" = "$CURRENT_WORKSPACE" ]; then
        update_cmd="$update_cmd --set $item background.drawing=on icon.color=$BLACK background.color=$YELLOW"
      else
        update_cmd="$update_cmd --set $item background.drawing=off icon.color=$WHITE"
      fi
    done
    
    if [ -n "$update_cmd" ]; then
      eval "sketchybar $update_cmd"
    fi
    # Continue to full update to ensure icons are shown
  fi
  
  # New workspace - create minimal item first, update later
  sketchybar --add item space.$CURRENT_WORKSPACE left \
    --set space.$CURRENT_WORKSPACE \
      background.color=$YELLOW \
      background.corner_radius=5 \
      background.height=26 \
      background.drawing=on \
      icon="$CURRENT_WORKSPACE" \
      icon.color=$BLACK \
      icon.padding_left=7 \
      icon.padding_right=7 \
      icon.font="Hack Nerd Font:Bold:18.0" \
      label.drawing=off \
      click_script="aerospace workspace $CURRENT_WORKSPACE" \
    --subscribe space.$CURRENT_WORKSPACE aerospace_workspace_change
  
  # Position it correctly
  spaces=$(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))' | sed 's/space\.//' | sort -g)
  prev_space=""
  for s in $spaces; do
    if [ "$s" -lt "$CURRENT_WORKSPACE" ] 2>/dev/null; then
      prev_space=$s
    fi
  done
  
  if [ -n "$prev_space" ]; then
    sketchybar --move space.$CURRENT_WORKSPACE after space.$prev_space
  else
    sketchybar --move space.$CURRENT_WORKSPACE after space_separator
  fi
  
  # Update other highlights
  update_cmd=""
  for s in $spaces; do
    if [ "$s" != "$CURRENT_WORKSPACE" ]; then
      update_cmd="$update_cmd --set space.$s background.drawing=off icon.color=$WHITE"
    fi
  done
  
  if [ -n "$update_cmd" ]; then
    eval "sketchybar $update_cmd"
  fi
  
  # Schedule async icon update for the new workspace
  (
    sleep 0.05
    apps=$(aerospace list-windows --workspace $CURRENT_WORKSPACE --format "%{app-name}" 2>/dev/null | sort | uniq)
    icon_string="$CURRENT_WORKSPACE"
    if [ -n "$apps" ]; then
      icon_string="${icon_string}  "
      first=true
      while IFS= read -r app; do
        icon=$(get_app_icon "$app")
        if [ "$first" = true ]; then
          icon_string="${icon_string}${icon}"
          first=false
        else
          icon_string="${icon_string} ${icon}"
        fi
      done <<< "$apps"
    fi
    sketchybar --set space.$CURRENT_WORKSPACE icon="$icon_string"
  ) &
  
  exit 0
fi

# Handle window movement events
if [ "$SENDER" = "window_moved" ]; then
  # Update all visible workspaces efficiently
  visible_workspaces=$(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))' | sed 's/space\.//')
  
  update_cmd=""
  for workspace in $visible_workspaces; do
    apps=$(aerospace list-windows --workspace $workspace --format "%{app-name}" 2>/dev/null | sort | uniq)
    
    icon_string="$workspace"
    if [ -n "$apps" ]; then
      icon_string="${icon_string}  "
      OLD_IFS="$IFS"
      IFS=$'\n'
      first=true
      for app in $apps; do
        icon=$(get_app_icon "$app")
        if [ "$first" = true ]; then
          icon_string="${icon_string}${icon}"
          first=false
        else
          icon_string="${icon_string} ${icon}"
        fi
      done
      IFS="$OLD_IFS"
    fi
    
    update_cmd="$update_cmd --set space.$workspace icon=\"$icon_string\" icon.font=\"Hack Nerd Font:Bold:18.0\""
  done
  
  if [ -n "$update_cmd" ]; then
    eval "sketchybar $update_cmd"
  fi
  exit 0
fi

# Get current workspace (use passed value if available, otherwise query)
CURRENT_WORKSPACE="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

# Cache all workspace windows in one call
cache_workspace_windows() {
  aerospace list-windows --all --format "%{workspace}:%{app-name}" 2>/dev/null | sort | uniq
}

# Function to get app icons for a workspace
get_workspace_apps() {
  local workspace=$1
  aerospace list-windows --workspace $workspace --format "%{app-name}" 2>/dev/null | sort | uniq
}

# Get all workspaces with windows (don't cache all windows, too slow)
WORKSPACES_WITH_WINDOWS=$(aerospace list-workspaces --monitor all --empty no 2>/dev/null | sort -g)

# Always include current workspace even if empty
if ! echo "$WORKSPACES_WITH_WINDOWS" | grep -q "^$CURRENT_WORKSPACE$"; then
  WORKSPACES_WITH_WINDOWS=$(echo -e "$CURRENT_WORKSPACE\n$WORKSPACES_WITH_WINDOWS" | sort -g | uniq)
fi

# Make sure we have at least the current workspace
if [ -z "$WORKSPACES_WITH_WINDOWS" ]; then
  WORKSPACES_WITH_WINDOWS="$CURRENT_WORKSPACE"
fi

# Get existing space items
EXISTING_SPACES=$(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))' | sed 's/space\.//')

# Remove spaces that no longer exist (but keep current workspace)
for space in $EXISTING_SPACES; do
  if [ "$space" != "$CURRENT_WORKSPACE" ] && ! echo "$WORKSPACES_WITH_WINDOWS" | grep -q "^$space$"; then
    sketchybar --remove space.$space
  fi
done

# Create or update space items
for workspace in $WORKSPACES_WITH_WINDOWS; do
  # Get apps in this workspace
  apps=$(get_workspace_apps $workspace)
  
  # Build icon string with workspace number and app icons
  icon_string="$workspace"
  if [ -n "$apps" ]; then
    # Add more space between number and apps
    icon_string="${icon_string}  "
    # Save IFS and set it to newline only
    OLD_IFS="$IFS"
    IFS=$'\n'
    first=true
    for app in $apps; do
      icon=$(get_app_icon "$app")
      if [ "$first" = true ]; then
        icon_string="${icon_string}${icon}"
        first=false
      else
        icon_string="${icon_string} ${icon}"  # One space between icons (reduced by ~60%)
      fi
    done
    IFS="$OLD_IFS"
  fi
  
  # Set colors based on whether it's focused
  if [ "$workspace" = "$CURRENT_WORKSPACE" ]; then
    bg_color=$YELLOW
    text_color=$BLACK
    drawing=on
  else
    bg_color=$BACKGROUND_1
    text_color=$WHITE
    drawing=off
  fi
  
  # Check if space already exists
  if sketchybar --query space.$workspace &>/dev/null; then
    # Update existing space
    sketchybar --set space.$workspace \
      icon="$icon_string" \
      icon.font="Hack Nerd Font:Bold:18.0" \
      icon.color=$text_color \
      background.color=$bg_color \
      background.drawing=$drawing \
      script="$PLUGIN_DIR/spaces.sh"
  else
    # Create new space - find the right position to insert it
    prev_space=""
    for ws in $(echo "$WORKSPACES_WITH_WINDOWS" | sort -g); do
      if [ "$ws" = "$workspace" ]; then
        break
      fi
      prev_space=$ws
    done
    
    if [ -n "$prev_space" ]; then
      # Insert after the previous workspace
      sketchybar --add item space.$workspace left \
        --move space.$workspace after space.$prev_space \
        --set space.$workspace \
          background.color=$bg_color \
          background.corner_radius=5 \
          background.height=26 \
          background.drawing=$drawing \
          icon="$icon_string" \
          icon.color=$text_color \
          icon.padding_left=7 \
          icon.padding_right=7 \
          icon.font="Hack Nerd Font:Bold:18.0" \
          label.drawing=off \
          click_script="aerospace workspace $workspace" \
          script="$PLUGIN_DIR/spaces.sh" \
        --subscribe space.$workspace aerospace_workspace_change
    else
      # This is the first workspace, add after separator
      sketchybar --add item space.$workspace left \
        --move space.$workspace after space_separator \
        --set space.$workspace \
          background.color=$bg_color \
          background.corner_radius=5 \
          background.height=26 \
          background.drawing=$drawing \
          icon="$icon_string" \
          icon.color=$text_color \
          icon.padding_left=7 \
          icon.padding_right=7 \
          icon.font="Hack Nerd Font:Bold:18.0" \
          label.drawing=off \
          click_script="aerospace workspace $workspace" \
          script="$PLUGIN_DIR/spaces.sh" \
        --subscribe space.$workspace aerospace_workspace_change
    fi
  fi
done

# Skip reordering - items are already inserted in correct positions

# Update the bracket
sketchybar --set spaces_bracket background.color=$BACKGROUND_1