#!/bin/bash

# Get current Wi-Fi status
WIFI_STATUS=$(networksetup -getairportpower en0 2>/dev/null | awk '{print $NF}')
IP=$(ipconfig getifaddr en0 2>/dev/null)

# Try to get current SSID - multiple methods
# Method 1: Using networksetup (sometimes works)
CURRENT_SSID=$(networksetup -getairportnetwork en0 2>/dev/null | grep -v "You are not associated" | sed 's/Current Wi-Fi Network: //')

# Method 2: Using system_profiler with better parsing
if [ -z "$CURRENT_SSID" ] || [ "$CURRENT_SSID" = "Infrastructure" ]; then
  CURRENT_SSID=$(system_profiler SPAirPortDataType 2>/dev/null | grep -A 1 "Current Network Information:" | tail -1 | sed 's/^ *//' | cut -d: -f1)
fi

# Method 3: Using ioreg with better parsing
if [ -z "$CURRENT_SSID" ] || [ "$CURRENT_SSID" = "Infrastructure" ]; then
  SSID_HEX=$(ioreg -r -n AirPortDriver | grep '"IO80211SSID"' | sed 's/.*<\(.*\)>.*/\1/' | sed 's/ //g')
  if [ -n "$SSID_HEX" ]; then
    CURRENT_SSID=$(echo "$SSID_HEX" | xxd -r -p 2>/dev/null | tr -d '\0')
  fi
fi

# If still no valid SSID but we have IP, just say connected
if ([ -z "$CURRENT_SSID" ] || [ "$CURRENT_SSID" = "Infrastructure" ]) && [ -n "$IP" ]; then
  CURRENT_SSID="Connected"
fi

# Create menu items
if [ "$WIFI_STATUS" = "Off" ]; then
  # If Wi-Fi is off, offer to turn it on
  sketchybar --set $NAME popup.drawing=toggle \
             --remove '/network.popup.*/' \
             --add item network.popup.wifi_toggle popup.$NAME \
             --set network.popup.wifi_toggle label="Turn Wi-Fi On" \
                   icon="󰤨" \
                   click_script="networksetup -setairportpower en0 on; sketchybar --set $NAME popup.drawing=off; sketchybar --trigger wifi_change"
else
  # Wi-Fi is on - show options
  sketchybar --set $NAME popup.drawing=toggle \
             --remove '/network.popup.*/'
  
  # Add current network info if connected
  if [ -n "$CURRENT_SSID" ]; then
    sketchybar --add item network.popup.current popup.$NAME \
               --set network.popup.current label="$CURRENT_SSID" \
                     icon="󰤨" \
                     label.color=0xff89b4fa \
                     click_script=""
    
    if [ -n "$IP" ]; then
      sketchybar --add item network.popup.ip popup.$NAME \
                 --set network.popup.ip label="IP: $IP" \
                       icon="󰩟" \
                       label.color=0xff6c7086 \
                       click_script=""
    fi
    
    sketchybar --add item network.popup.separator1 popup.$NAME \
               --set network.popup.separator1 label="───────────────" \
                     label.color=0xff45475a \
                     click_script=""
  fi
  
  # Add Wi-Fi toggle
  sketchybar --add item network.popup.wifi_toggle popup.$NAME \
             --set network.popup.wifi_toggle label="Turn Wi-Fi Off" \
                   icon="󰤮" \
                   click_script="networksetup -setairportpower en0 off; sketchybar --set $NAME popup.drawing=off; sketchybar --trigger wifi_change"
  
  # Add network preferences
  sketchybar --add item network.popup.preferences popup.$NAME \
             --set network.popup.preferences label="Network Preferences..." \
                   icon="󰒓" \
                   click_script="open /System/Library/PreferencePanes/Network.prefPane; sketchybar --set $NAME popup.drawing=off"
  
  # Add Wi-Fi diagnostics
  sketchybar --add item network.popup.diagnostics popup.$NAME \
             --set network.popup.diagnostics label="Wi-Fi Diagnostics..." \
                   icon="󰍉" \
                   click_script="open -a 'Wireless Diagnostics'; sketchybar --set $NAME popup.drawing=off"
  
  # Add separator
  sketchybar --add item network.popup.separator2 popup.$NAME \
             --set network.popup.separator2 label="───────────────" \
                   label.color=0xff45475a \
                   click_script=""
  
  # Add note about networks
  sketchybar --add item network.popup.networks_note popup.$NAME \
             --set network.popup.networks_note label="For other networks:" \
                   label.color=0xff6c7086 \
                   click_script=""
  
  sketchybar --add item network.popup.networks_note2 popup.$NAME \
             --set network.popup.networks_note2 label="Hold ⌥ + click menubar Wi-Fi" \
                   label.color=0xff6c7086 \
                   icon="󰘶" \
                   click_script=""
fi