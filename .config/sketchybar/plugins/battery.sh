#!/bin/bash

# Source icons
source "$CONFIG_DIR/icons.sh"

# Get battery info
BATTERY_INFO="$(pmset -g batt)"
PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "[0-9]+%" | cut -d'%' -f1)
CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')

if [ $PERCENTAGE = "" ]; then
  exit 0
fi

# Set icon based on percentage and charging status
if [[ $CHARGING != "" ]]; then
  ICON=$ICON_BATTERY_CHARGING
elif [[ $PERCENTAGE -ge 75 ]]; then
  ICON=$ICON_BATTERY_FULL
elif [[ $PERCENTAGE -ge 50 ]]; then
  ICON=$ICON_BATTERY_75
elif [[ $PERCENTAGE -ge 25 ]]; then
  ICON=$ICON_BATTERY_50
else
  ICON=$ICON_BATTERY_25
fi

sketchybar --set $NAME icon=$ICON label="${PERCENTAGE}%"