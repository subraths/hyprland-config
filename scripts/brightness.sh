#! /bin/sh

iDIR="$HOME/.config/mako/icons"

# Get maximum brightness dynamically
get_max_brightness() {
  brightnessctl max 2>/dev/null || echo "1"
}

# Get brightness
get_backlight() {
  LIGHT="$(brightnessctl g 2>/dev/null || echo "0")"
  MAX_LIGHT="$(get_max_brightness)"
  if [ "$MAX_LIGHT" -gt 0 ]; then
    echo "$((100 * LIGHT / MAX_LIGHT))"
  else
    echo "0"
  fi
}

# Get icons
get_icon() {
  current="$(get_backlight)"
  if [ "$current" -le 40 ]; then
    echo "$iDIR/brightness-low.png"
  elif [ "$current" -le 60 ]; then
    echo "$iDIR/brightness-mid.png"
  else
    echo "$iDIR/brightness-high.png"
  fi
}

# Notify
notify_user() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Brightness: $(get_backlight)%"
  else
    echo "Brightness: $(get_backlight)%"
  fi
}

# Increase brightness
inc_backlight() {
  if brightnessctl set +5% >/dev/null 2>&1; then
    notify_user
  else
    echo "Error: Failed to increase brightness" >&2
    exit 1
  fi
}

# Decrease brightness
dec_backlight() {
  if brightnessctl set 5%- >/dev/null 2>&1; then
    notify_user
  else
    echo "Error: Failed to decrease brightness" >&2
    exit 1
  fi
}

# Execute accordingly
case "$1" in
  "--get") get_backlight;;
  "--inc") inc_backlight;;
  "--dec") dec_backlight;;
  *) get_backlight;;
esac
