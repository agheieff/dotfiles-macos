#!/bin/bash

sketchybar --add item memory right \
           --set memory update_freq=5 \
                       icon=$ICON_MEMORY \
                       script="$PLUGIN_DIR/memory.sh" \
                       background.color=$BACKGROUND_1 \
                       background.corner_radius=5 \
                       background.height=26 \
                       background.padding_right=5 \
                       background.padding_left=5