#!/bin/bash

# Create dynamic workspaces based on what's active
sketchybar --add event aerospace_workspace_change
sketchybar --add event change-focused-window
sketchybar --add event windows_on_spaces

# Add a bracket for spaces
sketchybar --add bracket spaces_bracket \
           --set spaces_bracket background.color=$BACKGROUND_1 \
                               background.corner_radius=5 \
                               background.height=26 \
                               background.drawing=on

# Space separator
sketchybar --add item space_separator left \
           --set space_separator icon= \
                                icon.color=$GREY \
                                label.drawing=off \
                                background.drawing=off \
                                icon.padding_left=8 \
                                icon.padding_right=8

# Initialize the space display script
sketchybar --add item spaces_updater left \
           --set spaces_updater drawing=off \
                               updates=on \
                               script="$PLUGIN_DIR/spaces.sh" \
           --subscribe spaces_updater aerospace_workspace_change \
                                      front_app_switched

# Initialize the space display
"$PLUGIN_DIR/spaces.sh"