#!/bin/bash

# Display time only (for notch displays)
TIME=$(TZ="Europe/Prague" date '+%H:%M:%S')

sketchybar --set $NAME label="$TIME"