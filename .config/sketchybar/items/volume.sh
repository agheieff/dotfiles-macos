#!/bin/bash

sketchybar --add item volume right \
           --set volume script="$PLUGIN_DIR/volume.sh" \
                       icon=$ICON_VOLUME_MED \
                       background.color=$BACKGROUND_1 \
                       background.corner_radius=5 \
                       background.height=26 \
                       background.padding_right=5 \
                       background.padding_left=5 \
           --subscribe volume volume_change