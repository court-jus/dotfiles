#!/bin/bash

level=$(cat /sys/class/power_supply/BAT1/capacity)
batstatus=$(cat /sys/class/power_supply/BAT1/status)
symbol=""
color="lightgreen"

case $level in
[0-9])
    color="red"
    ;;
1[0-9])
    color="red"
    ;;
[2-3][0-9])
    color="orange"
    ;;
[4-5][0-9])
    color="yellow"
    ;;
[6-7][0-9])
    color="yellow"
    ;;
[8-9][0-9])
    ;;
100)
    ;;
*)
    ;;
esac

if [[ "$batstatus" = "Full" ]]; then
    symbol="="
elif [[ "$batstatus" = "Charging" ]]; then
    symbol="^"
else
    symbol="v"
fi

echo "<span font_desc='Fira Code Regular' foreground='${color}'>BAT $symbol $level%</span>"
