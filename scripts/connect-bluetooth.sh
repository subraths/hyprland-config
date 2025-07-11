#!/usr/bin/env bash

# Simple Bluetooth connection helper
# Usage: connect-bluetooth.sh [MAC_ADDRESS]

if [ $# -eq 1 ]; then
    # Connect to specific device
    MAC_ADDRESS="$1"
    echo "Attempting to connect to $MAC_ADDRESS..."
    if bluetoothctl connect "$MAC_ADDRESS"; then
        echo "Successfully connected to $MAC_ADDRESS"
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "Bluetooth" "Connected to $MAC_ADDRESS"
        fi
    else
        echo "Failed to connect to $MAC_ADDRESS" >&2
        if command -v notify-send >/dev/null 2>&1; then
            notify-send -u critical "Bluetooth" "Failed to connect to $MAC_ADDRESS"
        fi
        exit 1
    fi
else
    # Show paired devices and let user choose
    echo "Available paired devices:"
    bluetoothctl devices Paired
    echo ""
    echo "Usage: $0 [MAC_ADDRESS]"
    echo "Example: $0 AA:BB:CC:DD:EE:FF"
fi
