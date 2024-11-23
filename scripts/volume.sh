#! /usr/bin/env bash

iDIR="$HOME/.config/mako/icons"

# Get Volume
get_volume() {
  echo $(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2 * 100}')
}

is_muted() {
  muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $3}')
  if [ $muted == "[MUTED]" ]; then
    echo true
  else
    echo false
  fi
}

# Get icons
get_icon() {
	current=$(get_volume)
	if [[ "$current" -eq "0" || $(is_muted) == true ]]; then
		echo "$iDIR/volume-mute.png"
  else
		echo "$iDIR/volume.png"
	fi
}

# Notify
notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume : $(get_volume)%"
}

# Increase Volume
inc_volume() {
	wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%+ && notify_user
}

# Decrease Volume
dec_volume() {
	wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%- && notify_user
}

# Toggle Mute
toggle_mute() {
	if [ $(is_muted) == false ]; then
		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$iDIR/volume-mute.png" "Volume Switched OFF"
	elif [ $(is_muted) == true ]; then
		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Volume Switched ON"
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
