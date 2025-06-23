#!/bin/bash

MENU_NAME="$1"

# Use AppleScript to click the menu
osascript <<EOF
tell application "System Events"
    tell (first application process whose frontmost is true)
        click menu bar item "$MENU_NAME" of menu bar 1
    end tell
end tell
EOF