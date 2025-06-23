#!/bin/bash

# Format matching your waybar: "󰥔 Mon Dec 23 11:45:30"
# Using Prague timezone
export TZ='Europe/Prague'
TIME=$(date '+%a %b %d %H:%M:%S')

sketchybar --set $NAME label="$TIME"