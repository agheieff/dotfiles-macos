#!/bin/bash

# Source icons
source "$CONFIG_DIR/icons.sh"

# Get volume info
VOLUME=$(osascript -e 'output volume of (get volume settings)')
MUTED=$(osascript -e 'output muted of (get volume settings)')

if [[ $MUTED == "true" ]]; then
  ICON=$ICON_VOLUME_MUTE
  VOLUME="MUTE"
else
  case ${VOLUME} in
    [6-9][0-9]|100) ICON=$ICON_VOLUME_HIGH ;;
    [3-5][0-9]) ICON=$ICON_VOLUME_MED ;;
    [1-2][0-9]) ICON=$ICON_VOLUME_LOW ;;
    *) ICON=$ICON_VOLUME_MUTE ;;
  esac
  VOLUME="${VOLUME}%"
fi

sketchybar --set $NAME icon=$ICON label="$VOLUME"