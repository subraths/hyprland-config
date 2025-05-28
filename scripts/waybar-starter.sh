#!/usr/bin/env sh

sleep 1
# Check if Waybar is already running
if pgrep -x "waybar" > /dev/null; then
    echo "Waybar is already running."
else
    # Start Waybar
    waybar &
    echo "Waybar started."
fi
