#!/bin/bash

sketchybar --add item cpu right \
           --set cpu update_freq=2 \
                    icon=$ICON_CPU \
                    script="$PLUGIN_DIR/cpu.sh" \
                    background.color=$BACKGROUND_1 \
                    background.corner_radius=5 \
                    background.height=26 \
                    background.padding_right=5 \
                    background.padding_left=5