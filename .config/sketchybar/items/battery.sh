#!/bin/bash

sketchybar --add item battery right \
           --set battery update_freq=60 \
                        script="$PLUGIN_DIR/battery.sh" \
                        background.color=$BACKGROUND_1 \
                        background.corner_radius=5 \
                        background.height=26 \
                        background.padding_right=5 \
                        background.padding_left=5 \
           --subscribe battery system_woke power_source_change