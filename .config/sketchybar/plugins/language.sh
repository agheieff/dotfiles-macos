#!/bin/bash

# Get current input source using a more reliable method
SOURCE=$(osascript -e 'tell application "System Events" to tell process "SystemUIServer"
  get the value of the first menu bar item of menu bar 1 whose description contains "text input"
end tell' 2>/dev/null | sed 's/^U.S.$/US/')

# If that fails, try using the input source directly
if [ -z "$SOURCE" ] || [ "$SOURCE" = "missing value" ]; then
  # Try to get from system
  SOURCE=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources 2>/dev/null | plutil -convert xml1 -o - - | grep -A1 "KeyboardLayout Name" | tail -1 | sed 's/<[^>]*>//g' | xargs)
fi

# Default if still nothing
if [ -z "$SOURCE" ]; then
  SOURCE="US"
fi

# Map to short names like in your waybar config
case "$SOURCE" in
  "U.S."|"US") LABEL="US" ;;
  "Colemak") LABEL="CO" ;;
  "Russian"|"Russian-PC"|"RussianWin") LABEL="RU" ;;
  "Czech"|"Czech-QWERTY") LABEL="CZ" ;;
  "ABC") LABEL="ABC" ;;
  *Pinyin*) LABEL="中" ;;
  *) LABEL=$(echo "$SOURCE" | cut -c1-2 | tr '[:lower:]' '[:upper:]') ;;
esac

sketchybar --set ${NAME:-language} label="$LABEL"