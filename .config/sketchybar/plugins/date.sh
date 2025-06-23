#!/bin/bash

# Display date only (for notch displays)
DATE=$(TZ="Europe/Prague" date '+%a %d %b')

sketchybar --set $NAME label="$DATE"