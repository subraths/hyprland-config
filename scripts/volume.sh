#! /usr/bin/env bash

iDIR="$HOME/.config/mako/icons"

# Get Volume
get_volume() {
  if command -v wpctl >/dev/null 2>&1; then
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{printf "%.0f", $2 * 100}' || echo "0"
  else
    echo "0"
  fi
}

# Check if muted
is_muted() {
  if command -v wpctl >/dev/null 2>&1; then
    muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{print $3}')
    if [ "$muted" = "[MUTED]" ]; then
      echo true
    else
      echo false
    fi
  else
    echo false
  fi
}

# Get icons
get_icon() {
  current=$(get_volume)
  if [ "$current" -eq "0" ] || [ "$(is_muted)" = "true" ]; then
    echo "$iDIR/volume-mute.png"
  else
    echo "$iDIR/volume.png"
  fi
}

# Notify
notify_user() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume: $(get_volume)%"
  else
    echo "Volume: $(get_volume)%"
  fi
}

# Increase Volume
inc_volume() {
  if command -v wpctl >/dev/null 2>&1; then
    if wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ 2>/dev/null; then
      notify_user
    else
      echo "Error: Failed to increase volume" >&2
      exit 1
    fi
  else
    echo "Error: wpctl not found" >&2
    exit 1
  fi
}

# Decrease Volume
dec_volume() {
  if command -v wpctl >/dev/null 2>&1; then
    if wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%- 2>/dev/null; then
      notify_user
    else
      echo "Error: Failed to decrease volume" >&2
      exit 1
    fi
  else
    echo "Error: wpctl not found" >&2
    exit 1
  fi
}

# Toggle Mute
toggle_mute() {
  if command -v wpctl >/dev/null 2>&1; then
    if wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle 2>/dev/null; then
      if [ "$(is_muted)" = "false" ]; then
        if command -v notify-send >/dev/null 2>&1; then
          notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-mute.png" "Volume Muted"
        else
          echo "Volume Muted"
        fi
      else
        if command -v notify-send >/dev/null 2>&1; then
          notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume Unmuted"
        else
          echo "Volume Unmuted"
        fi
      fi
    else
      echo "Error: Failed to toggle mute" >&2
      exit 1
    fi
  else
    echo "Error: wpctl not found" >&2
    exit 1
  fi
}

# Execute accordingly
case "$1" in
  "--get") get_volume;;
  "--inc") inc_volume;;
  "--dec") dec_volume;;
  "--toggle") toggle_mute;;
  *) get_volume;;
esac
