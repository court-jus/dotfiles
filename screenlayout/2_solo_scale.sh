#!/bin/sh
xrandr \
    --output eDP-1 \
        --primary \
        --mode 1920x1080 \
        --scale 0.5x0.5 \
        --pos 0x0 \
        --rotate normal \
    --output DP-1 \
        --off \
    --output HDMI-1 \
        --off \
    --output HDMI-2 \
        --off
