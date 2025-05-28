#!/usr/bin/env bash

get_temp() {
  echo `hyprctl hyprsunset temperature`
}

increase_temp() {
  local current_temp
  current_temp=$(get_temp)
  hyprctl hyprsunset temperature $((current_temp + 500))
}

decrease_temp() {
  local current_temp
  current_temp=$(get_temp)
  hyprctl hyprsunset temperature $((current_temp - 500))
}

invalid_arg() {
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "invalid arg"
}

case "$1" in
  "--inc") increase_temp;;
  "--dec") decrease_temp;;
  *) invalid_arg;;
esac
