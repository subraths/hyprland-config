#! /bin/sh

iDIR="$HOME/.config/mako/icons"

# Get microphone volume using wpctl or pamixer as fallback
get_mic_volume() {
  if command -v wpctl >/dev/null 2>&1; then
    wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk '{printf "%.0f", $2 * 100}' || echo "0"
  elif command -v pamixer >/dev/null 2>&1; then
    pamixer --default-source --get-volume 2>/dev/null || echo "0"
  else
    echo "0"
  fi
}

# Check if microphone is muted
is_mic_muted() {
  if command -v wpctl >/dev/null 2>&1; then
    muted=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | awk '{print $3}')
    if [ "$muted" = "[MUTED]" ]; then
      echo true
    else
      echo false
    fi
  elif command -v pamixer >/dev/null 2>&1; then
    if [ "$(pamixer --default-source --get-mute 2>/dev/null)" = "true" ]; then
      echo true
    else
      echo false
    fi
  else
    echo false
  fi
}

# Get microphone icon
get_mic_icon() {
  if [ "$(is_mic_muted)" = "true" ]; then
    echo "$iDIR/microphone-mute.png"
  else
    echo "$iDIR/microphone.png"
  fi
}

# Notify user about microphone status
notify_mic_user() {
  if command -v notify-send >/dev/null 2>&1; then
    if [ "$(is_mic_muted)" = "true" ]; then
      notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_mic_icon)" "Microphone: Muted"
    else
      notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_mic_icon)" "Microphone: $(get_mic_volume)%"
    fi
  else
    if [ "$(is_mic_muted)" = "true" ]; then
      echo "Microphone: Muted"
    else
      echo "Microphone: $(get_mic_volume)%"
    fi
  fi
}

# Toggle microphone mute
toggle_mic() {
  if command -v wpctl >/dev/null 2>&1; then
    if wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle 2>/dev/null; then
      notify_mic_user
    else
      echo "Error: Failed to toggle microphone" >&2
      exit 1
    fi
  elif command -v pamixer >/dev/null 2>&1; then
    if pamixer --default-source --toggle-mute 2>/dev/null; then
      notify_mic_user
    else
      echo "Error: Failed to toggle microphone" >&2
      exit 1
    fi
  else
    echo "Error: No audio control utility found (wpctl or pamixer required)" >&2
    exit 1
  fi
}

# Increase microphone volume
inc_mic_volume() {
  if command -v wpctl >/dev/null 2>&1; then
    if wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 5%+ 2>/dev/null; then
      notify_mic_user
    else
      echo "Error: Failed to increase microphone volume" >&2
      exit 1
    fi
  elif command -v pamixer >/dev/null 2>&1; then
    if pamixer --default-source -i 5 2>/dev/null; then
      notify_mic_user
    else
      echo "Error: Failed to increase microphone volume" >&2
      exit 1
    fi
  else
    echo "Error: No audio control utility found (wpctl or pamixer required)" >&2
    exit 1
  fi
}

# Decrease microphone volume
dec_mic_volume() {
  if command -v wpctl >/dev/null 2>&1; then
    if wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 5%- 2>/dev/null; then
      notify_mic_user
    else
      echo "Error: Failed to decrease microphone volume" >&2
      exit 1
    fi
  elif command -v pamixer >/dev/null 2>&1; then
    if pamixer --default-source -d 5 2>/dev/null; then
      notify_mic_user
    else
      echo "Error: Failed to decrease microphone volume" >&2
      exit 1
    fi
  else
    echo "Error: No audio control utility found (wpctl or pamixer required)" >&2
    exit 1
  fi
}

# Execute accordingly
case "$1" in
  "--get") get_mic_volume;;
  "--inc") inc_mic_volume;;
  "--dec") dec_mic_volume;;
  "--toggle") toggle_mic;;
  "--muted") is_mic_muted;;
  *) echo "Usage: $0 {--get|--inc|--dec|--toggle|--muted}"; exit 1;;
esac
