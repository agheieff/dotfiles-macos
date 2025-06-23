#!/bin/bash

sketchybar --add item apple right \
           --set apple icon=󰐥 \
                      icon.font="SF Pro:Regular:20.0" \
                      icon.color=$WHITE \
                      background.color=$BACKGROUND_1 \
                      background.corner_radius=5 \
                      background.height=26 \
                      background.padding_right=5 \
                      background.padding_left=5 \
                      padding_right=10 \
                      label.drawing=off \
                      click_script="$PLUGIN_DIR/apple_menu.sh" \
                      popup.blur_radius=20 \
                      popup.background.color=$POPUP_BACKGROUND_COLOR \
                      popup.background.corner_radius=5 \
                      popup.align=right \
                      popup.y_offset=5

# Add menu items with consistent padding
POPUP_PADDING="label.padding_left=5 label.padding_right=20 icon.padding_left=5"

sketchybar --add item apple.about popup.apple \
           --set apple.about icon="󰋼" \
                            label="About This Mac" \
                            $POPUP_PADDING \
                            click_script="open -b com.apple.systempreferences; sketchybar --set apple popup.drawing=off" \
           \
           --add item apple.settings popup.apple \
           --set apple.settings icon="󰒓" \
                               label="System Settings..." \
                               $POPUP_PADDING \
                               click_script="open -b com.apple.systempreferences; sketchybar --set apple popup.drawing=off" \
           \
           --add item apple.activity popup.apple \
           --set apple.activity icon="󰨇" \
                               label="Activity Monitor" \
                               $POPUP_PADDING \
                               click_script="open -b com.apple.ActivityMonitor; sketchybar --set apple popup.drawing=off" \
           \
           --add item apple.separator popup.apple \
           --set apple.separator icon="" \
                                label="" \
                                background.drawing=on \
                                background.color=$GREY \
                                background.height=1 \
                                width=150 \
                                click_script="" \
           \
           --add item apple.lock popup.apple \
           --set apple.lock icon="󰌾" \
                           label="Lock Screen" \
                           $POPUP_PADDING \
                           click_script="pmset displaysleepnow; sketchybar --set apple popup.drawing=off" \
           \
           --add item apple.logout popup.apple \
           --set apple.logout icon="󰍃" \
                             label="Log Out..." \
                             $POPUP_PADDING \
                             click_script="osascript -e 'tell app \"System Events\" to log out'; sketchybar --set apple popup.drawing=off" \
           \
           --add item apple.reboot popup.apple \
           --set apple.reboot icon="󰜉" \
                             label="Restart..." \
                             $POPUP_PADDING \
                             click_script="osascript -e 'tell app \"System Events\" to restart'; sketchybar --set apple popup.drawing=off" \
           \
           --add item apple.shutdown popup.apple \
           --set apple.shutdown icon="󰐥" \
                               label="Shut Down..." \
                               $POPUP_PADDING \
                               click_script="osascript -e 'tell app \"System Events\" to shut down'; sketchybar --set apple popup.drawing=off"