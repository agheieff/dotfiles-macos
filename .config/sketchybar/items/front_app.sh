#!/bin/bash

sketchybar --add item front_app left \
           --set front_app script="$PLUGIN_DIR/front_app.sh" \
                          icon.drawing=off \
                          background.color=$BACKGROUND_1 \
                          background.corner_radius=5 \
                          background.height=26 \
                          label.color=$WHITE \
                          label.padding_left=10 \
                          label.padding_right=10 \
           --subscribe front_app front_app_switched