#!/bin/bash

# Get frontmost app name
APP_NAME=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true')

sketchybar --set $NAME label="$APP_NAME"