#!/bin/bash

# Add toggle button (or we can use a keyboard shortcut)
sketchybar --add item menubar_toggle left \
           --set menubar_toggle icon="󰍜" \
                               icon.font="Hack Nerd Font:Regular:17.0" \
                               icon.color=$GREY \
                               background.color=$BACKGROUND_1 \
                               background.corner_radius=5 \
                               background.height=26 \
                               background.padding_right=5 \
                               background.padding_left=5 \
                               label.drawing=off \
                               click_script="$PLUGIN_DIR/toggle_menubar.sh" \
           --add item menubar_separator left \
           --set menubar_separator icon="|" \
                                  icon.color=$GREY \
                                  label.drawing=off \
                                  background.drawing=off \
                                  icon.padding_left=3 \
                                  icon.padding_right=5

# Hidden menu items container
sketchybar --add item menu_container left \
           --set menu_container drawing=off