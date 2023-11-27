#!/usr/bin/env bash

if [ "$1" != "M" ]; then
  pulsemixer --change-volume "$1"
  # ~/bin/pactl_getvol.sh
elif [ "$(pulsemixer --get-mute)" == "1" ]; then
  pulsemixer --unmute
else
  pulsemixer --mute
fi

pkill -RTMIN+12 i3blocks
