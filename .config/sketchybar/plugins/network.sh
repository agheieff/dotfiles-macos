#!/bin/bash

# Get the current Wi-Fi status
WIFI_STATUS=$(networksetup -getairportpower en0 2>/dev/null | awk '{print $NF}')
ICON="󰤮"  # Default off icon

if [ "$WIFI_STATUS" = "On" ]; then
  # Check if we have an IP address (indicates connection)
  IP=$(ipconfig getifaddr en0 2>/dev/null)
  
  if [ -n "$IP" ]; then
    # We're connected - just show connected icon
    ICON="󰤨"  # Connected icon
  else
    # No IP address, not connected
    ICON="󰤯"  # No connection icon
  fi
else
  # Wi-Fi is off
  ICON="󰤮"  # Off icon
fi

sketchybar --set $NAME icon="$ICON"