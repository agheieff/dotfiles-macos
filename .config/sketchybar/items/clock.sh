#!/bin/bash

# Check for internal display with notch (MacBook Pro 14" or 16" with notch)
INTERNAL_DISPLAY_NAME=$(system_profiler SPDisplaysDataType 2>/dev/null | grep -A 5 "Displays:" | grep -A 5 "Built-in" | grep "Display Type" | head -1)

# MacBooks with notch have specific display names or model numbers
MODEL=$(sysctl -n hw.model)
if [[ "$INTERNAL_DISPLAY_NAME" == *"Built-in Liquid Retina"* ]] || \
   [[ "$MODEL" == "MacBookPro18"* ]] || \
   [[ "$MODEL" == "MacBookAir10"* ]] || \
   [[ "$MODEL" == "Mac14"* ]] || \
   [[ "$MODEL" == "Mac15"* ]]; then
  
  # Has notch: create split time/date without background
  # Time on the left side of notch
  sketchybar --add item time_left center \
             --set time_left update_freq=1 \
                            icon.drawing=off \
                            script="$PLUGIN_DIR/time.sh" \
                            background.drawing=off \
                            label.padding_right=10 \
                            label.padding_left=10 \
                            position=q \
                            y_offset=0 \
                            display=1
  
  # Date on the right side of notch
  sketchybar --add item date_right center \
             --set date_right update_freq=60 \
                             icon.drawing=off \
                             script="$PLUGIN_DIR/date.sh" \
                             background.drawing=off \
                             label.padding_right=10 \
                             label.padding_left=10 \
                             position=e \
                             y_offset=0 \
                             display=1
  
  # Use default positioning (0px adjustment)
  sketchybar --set time_left label.padding_right=0 \
             --set date_right label.padding_left=0
  
  # External displays still get normal clock
  sketchybar --add item clock center \
             --set clock update_freq=1 \
                        icon=$ICON_CLOCK \
                        script="$PLUGIN_DIR/clock.sh" \
                        background.color=$BACKGROUND_1 \
                        background.corner_radius=5 \
                        background.height=26 \
                        background.padding_right=5 \
                        background.padding_left=5 \
                        display=2,3,4,5
else
  # No notch: standard clock
  sketchybar --add item clock center \
             --set clock update_freq=1 \
                        icon=$ICON_CLOCK \
                        script="$PLUGIN_DIR/clock.sh" \
                        background.color=$BACKGROUND_1 \
                        background.corner_radius=5 \
                        background.height=26 \
                        background.padding_right=5 \
                        background.padding_left=5
fi