#!/bin/bash

# Get CPU usage
CPU=$(top -l 2 -n 0 -F | grep -E "^CPU" | tail -1 | awk '{print $3}' | cut -d'%' -f1)

sketchybar --set $NAME label="${CPU}%"