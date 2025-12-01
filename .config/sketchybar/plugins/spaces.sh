#!/bin/bash

# Get the directory paths
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$PLUGIN_DIR")"

# Source colors
source "$CONFIG_DIR/colors.sh"

# ---------- 1.  keep the last workspace we were in ------------
CACHE_DIR="${TMPDIR:-/tmp}/sketchybar-aerospace"
mkdir -p "$CACHE_DIR"
LAST_FILE="$CACHE_DIR/last_workspace"

# Function to get icon for an app
get_app_icon() {
  local app="$1"
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

# Build icon string for a workspace
build_icon_string() {
  local workspace="$1"
  local apps="$2"
  
  local icon_string="$workspace"
  if [ -n "$apps" ]; then
    icon_string="${icon_string} "
    local first=1
    while IFS= read -r app; do
      # Trim whitespace
      app=$(echo "$app" | xargs)
      if [ -n "$app" ]; then
        local icon=$(get_app_icon "$app")
        if [ $first -eq 1 ]; then
          icon_string="${icon_string}${icon}"
          first=0
        else
          icon_string="${icon_string} ${icon}"
        fi
      fi
    done <<< "$apps"
  fi
  
  echo "$icon_string"
}

# Get sorted list of all workspaces that have windows
get_active_workspaces() {
  aerospace list-workspaces --monitor all --empty no 2>/dev/null | sort -g
}

# Update positions of all space items to maintain numeric order
update_space_positions() {
  local current_workspace="$1"
  
  # Get all active workspaces
  local workspaces=$(get_active_workspaces)
  
  # Always include current workspace even if empty
  if ! echo "$workspaces" | grep -q "^$current_workspace$"; then
    workspaces=$(echo -e "$current_workspace\n$workspaces" | sort -g | uniq)
  fi
  
  # Make sure we have at least the current workspace
  if [ -z "$workspaces" ]; then
    workspaces="$current_workspace"
  fi
  
  # Position spaces in correct numeric order
  local prev_item="space_separator"
  for workspace in $workspaces; do
    if sketchybar --query space.$workspace >/dev/null 2>&1; then
      sketchybar --move space.$workspace after $prev_item 2>/dev/null
      prev_item="space.$workspace"
    fi
  done
}

# ---------- 2.  workspace-change handler ----------------------
if [ "$SENDER" = "aerospace_workspace_change" ]; then
    # where we are going
    CURRENT_WORKSPACE="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
    [ -z "$CURRENT_WORKSPACE" ] && CURRENT_WORKSPACE=1

    # where we just came from
    LAST_WORKSPACE=$(<"$LAST_FILE" 2>/dev/null)

    # delete the old workspace-item if it is now empty and not the one we just entered
    if [[ -n $LAST_WORKSPACE && $LAST_WORKSPACE != "$CURRENT_WORKSPACE" ]]; then
        last_apps=$(aerospace list-windows --workspace "$LAST_WORKSPACE" --format "%{app-name}" 2>/dev/null)
        if [[ -z $last_apps ]]; then
            sketchybar --remove "space.$LAST_WORKSPACE" 2>/dev/null
        fi
    fi

    # remember for the next switch
    echo "$CURRENT_WORKSPACE" > "$LAST_FILE"

    # Update highlighting: turn off all, turn on current
    sketchybar --set '/space\..*/' background.drawing=off icon.color=$WHITE background.color=$BACKGROUND_1 2>/dev/null
    sketchybar --set space.$CURRENT_WORKSPACE background.drawing=on icon.color=$BLACK background.color=$YELLOW 2>/dev/null
    
    # Create workspace item if it doesn't exist
    if ! sketchybar --query space.$CURRENT_WORKSPACE >/dev/null 2>&1; then
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
        --subscribe space.$CURRENT_WORKSPACE aerospace_workspace_change 2>/dev/null
    fi
    
    # Update icon for current workspace (do this async to not block)
    (
      sleep 0.05
      apps=$(aerospace list-windows --workspace $CURRENT_WORKSPACE --format "%{app-name}" 2>/dev/null | sort | uniq)
      icon_string=$(build_icon_string "$CURRENT_WORKSPACE" "$apps")
      sketchybar --set space.$CURRENT_WORKSPACE icon="$icon_string" 2>/dev/null
    ) &
    
    exit 0
fi

# Handle window moved event
if [ "$SENDER" = "window_moved" ]; then
  # Get current workspace
  CURRENT_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
  [ -z "$CURRENT_WORKSPACE" ] && CURRENT_WORKSPACE="1"
  
  # Get all active workspaces
  WORKSPACES=$(get_active_workspaces)
  
  # Always include current workspace even if empty
  if ! echo "$WORKSPACES" | grep -q "^$CURRENT_WORKSPACE$"; then
    WORKSPACES=$(echo -e "$CURRENT_WORKSPACE
$WORKSPACES" | sort -g | uniq)
  fi
  
  # Make sure we have at least the current workspace
  if [ -z "$WORKSPACES" ]; then
    WORKSPACES="$CURRENT_WORKSPACE"
  fi
  
  # Create a list of workspaces that should exist
  VALID_WORKSPACES=""
  
  # Update or create items for all workspaces
  for workspace in $WORKSPACES; do
    # Add to valid workspaces list
    if [ -z "$VALID_WORKSPACES" ]; then
      VALID_WORKSPACES="$workspace"
    else
      VALID_WORKSPACES="$VALID_WORKSPACES $workspace"
    fi
    
    # Get apps in this workspace
    apps=$(aerospace list-windows --workspace $workspace --format "%{app-name}" 2>/dev/null | sort | uniq)
    
    # Build icon string
    icon_string=$(build_icon_string "$workspace" "$apps")
    
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
    
    # Update or create space item
    if sketchybar --query space.$workspace >/dev/null 2>&1; then
      sketchybar --set space.$workspace 
        icon="$icon_string" 
        icon.color=$text_color 
        background.color=$bg_color 
        background.drawing=$drawing 2>/dev/null
    else
      sketchybar --add item space.$workspace left 
        --set space.$workspace 
          background.color=$bg_color 
          background.corner_radius=5 
          background.height=26 
          background.drawing=$drawing 
          icon="$icon_string" 
          icon.color=$text_color 
          icon.padding_left=7 
          icon.padding_right=7 
          icon.font="Hack Nerd Font:Bold:18.0" 
          label.drawing=off 
          click_script="aerospace workspace $workspace" 
        --subscribe space.$workspace aerospace_workspace_change 2>/dev/null
    fi
  done
  
  # Update positions to maintain correct order
  update_space_positions "$CURRENT_WORKSPACE"
  
  exit 0
fi

# Full refresh (initialization or manual trigger)
# Get current workspace
CURRENT_WORKSPACE="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
[ -z "$CURRENT_WORKSPACE" ] && CURRENT_WORKSPACE="1"

# Get all active workspaces
WORKSPACES=$(get_active_workspaces)

# Always include current workspace even if empty
if ! echo "$WORKSPACES" | grep -q "^$CURRENT_WORKSPACE$"; then
  WORKSPACES=$(echo -e "$CURRENT_WORKSPACE
$WORKSPACES" | sort -g | uniq)
fi

# Make sure we have at least the current workspace
if [ -z "$WORKSPACES" ]; then
  WORKSPACES="$CURRENT_WORKSPACE"
fi

# Create a list of workspaces that should exist
VALID_WORKSPACES=""

# Update or create items for all workspaces
for workspace in $WORKSPACES; do
  # Add to valid workspaces list
  if [ -z "$VALID_WORKSPACES" ]; then
    VALID_WORKSPACES="$workspace"
  else
    VALID_WORKSPACES="$VALID_WORKSPACES $workspace"
  fi
  
  # Get apps in this workspace
  apps=$(aerospace list-windows --workspace $workspace --format "%{app-name}" 2>/dev/null | sort | uniq)
  
  # Build icon string
  icon_string=$(build_icon_string "$workspace" "$apps")
  
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
  
  # Update or create space item
  if sketchybar --query space.$workspace >/dev/null 2>&1; then
    sketchybar --set space.$workspace \
      icon="$icon_string" \
      icon.font="Hack Nerd Font:Bold:18.0" \
      icon.color=$text_color \
      background.color=$bg_color \
      background.drawing=$drawing 2>/dev/null
  else
    sketchybar --add item space.$workspace left \
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
      --subscribe space.$workspace aerospace_workspace_change 2>/dev/null
  fi
done

# Remove spaces that no longer exist or are empty (except current)
existing_spaces=$(sketchybar --query bar 2>/dev/null | jq -r '.items[] | select(startswith("space."))' 2>/dev/null | sed 's/space\\.//')
for space in $existing_spaces; do
  # Check if this space should still exist
  should_exist=0
  for valid_space in $VALID_WORKSPACES; do
    if [ "$space" = "$valid_space" ]; then
      should_exist=1
      break
    fi
  done
  
  # Special case: Remove empty workspaces that are not the current one
  if [ $should_exist -eq 0 ] || ([ $should_exist -eq 1 ] && [ "$space" != "$CURRENT_WORKSPACE" ]); then
    # Check if the space is empty and not the current one
    if [ "$space" != "$CURRENT_WORKSPACE" ]; then
      space_apps=$(aerospace list-windows --workspace $space --format "%{app-name}" 2>/dev/null)
      if [ -z "$space_apps" ]; then
        sketchybar --remove space.$space 2>/dev/null
      fi
    fi
  fi
done

# Update positions to maintain correct order
update_space_positions "$CURRENT_WORKSPACE"

# Update the bracket
sketchybar --set spaces_bracket background.color=$BACKGROUND_1 2>/dev/null