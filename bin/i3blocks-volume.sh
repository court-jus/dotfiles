#!/bin/bash

level=$(pulsemixer --get-volume | awk '{print $1}')
muted=$(pulsemixer --get-mute)
symbol="🔈"
color="red"

case $level in
[0-9])
    symbol="🔈"
    color="lightgreen"
    ;;
1[0-9])
    symbol="🔉"
    color="lightgreen"
    ;;
[2-3][0-9])
    symbol="🔉"
    color="yellow"
    ;;
[4-5][0-9])
    symbol="🔊"
    color="yellow"
    ;;
[6-7][0-9])
    symbol="🔊"
    color="orange"
    ;;
[8-9][0-9])
    symbol="🔊"
    ;;
100)
    symbol="🔊"
    ;;
*)
    symbol="🔊"
    ;;
esac

if [ "$muted" = "1" ]; then
    symbol="🔇"
    color="white"
fi


echo "<span font_desc='Fira Code Regular' foreground='${color}'>$symbol $level</span>"
