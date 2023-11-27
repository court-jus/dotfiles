#!/bin/bash

level=$(df "$1" --output=pcent | tail -n1 | sed -e "s/%//g" -e "s/^ *//g")
color="red"

case $level in
[0-9])
    color="lightgreen"
    ;;
1[0-9])
    color="lightgreen"
    ;;
[2-3][0-9])
    color="lightgreen"
    ;;
[4-5][0-9])
    color="yellow"
    ;;
[6-7][0-9])
    color="orange"
    ;;
[8-9][0-9])
    color="orange"
    ;;
esac

echo "<span font_desc='Fira Code Regular' foreground='${color}'>$1: $level%</span>"
