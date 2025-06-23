#!/bin/bash

sketchybar --add item language right \
           --set language update_freq=3 \
                         icon.drawing=off \
                         script="$PLUGIN_DIR/language.sh" \
                         background.color=$BACKGROUND_1 \
                         background.corner_radius=5 \
                         background.height=26 \
                         background.padding_right=5 \
                         background.padding_left=5 \
                         click_script="open /System/Library/PreferencePanes/Keyboard.prefPane"