#! /bin/sh

iDIR="$HOME/.config/mako/icons"

# Get brightness
get_backlight() {
  LIGHT="$(brightnessctl g)"
  echo "$((100 * LIGHT/937))"
}

# Get icons
get_icon() {
  current="$(get_backlight)"
  if [[ ("$current" -ge "0") && ("$current" -le "40") ]]; then
    echo "$iDIR/brightness-low.png"
  elif [[ ("$current" -ge "40") && ("$current" -le "60") ]]; then
    echo "$iDIR/brightness-mid.png"
  elif [[ ("$current" -ge "60") && ("$current" -le "100") ]]; then
    echo "$iDIR/brightness-high.png"
  fi
}

# Notify
notify_user() {
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Brightness : "$(get_backlight)"%"
}

# Increase brightness
inc_backlight() {
  brightnessctl set +1% && notify_user
}

# Decrease brightness
dec_backlight() {
  brightnessctl set 1%- && notify_user
}

# Execute accordingly
case "$1" in
  "--get") get_backlight;;
  "--inc") inc_backlight;;
  "--dec") dec_backlight;;
  *) get_backlight;;
esac
