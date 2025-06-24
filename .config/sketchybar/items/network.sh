#!/bin/bash

sketchybar --add item network right \
           --set network \
                 icon="󰤨" \
                 icon.font="Hack Nerd Font:Regular:20.0" \
                 label.drawing=off \
                 background.color=$BACKGROUND_1 \
                 background.corner_radius=5 \
                 background.height=26 \
                 background.padding_right=5 \
                 background.padding_left=5 \
                 script="$PLUGIN_DIR/network.sh" \
                 click_script="$PLUGIN_DIR/network_click.sh" \
           --subscribe network wifi_change system_woke