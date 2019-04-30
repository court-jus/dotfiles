#!/usr/bin/env bash

killall osd_cat
pulsemixer --get-volume | awk '{print $1}' | osd_cat  -d 2 -s 1 -A center -p bottom -f '-*-fixed-*-*-*-*-*-600-*-*-*-*-*-*'

