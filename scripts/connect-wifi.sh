#! /bin/sh

iDIR="$HOME/.config/mako/icons/wifi.png"

get_icon() {
  echo "$iDIR"
}

iwctl station wlan0 scan
# iwctl station wlan0 connect AndroidAP_6771
notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Scanning wifi..."
