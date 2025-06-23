#!/bin/bash

sketchybar --add item brightness right \
           --set brightness script="$PLUGIN_DIR/brightness.sh" \
                           icon=󰃠 \
                           icon.font="Hack Nerd Font:Regular:20.0" \
                           label.drawing=on \
                           background.color=$BACKGROUND_1 \
                           background.corner_radius=5 \
                           background.height=26 \
                           icon.padding_left=5 \
                           icon.padding_right=5 \
                           label.padding_left=0 \
                           label.padding_right=5 \
                           update_freq=5 \
           --subscribe brightness brightness_change