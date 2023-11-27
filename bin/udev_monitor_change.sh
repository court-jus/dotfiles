#!/bin/bash

# /etc/udev/rules.d/80-monitor.rules contains :
# ACTION=="change", SUBSYSTEM=="drm", RUN+="/home/ghislain/bin/udev_monitor_change.sh"

# Three monitors (regular setup)
# eDP-1 connected primary 1280x720+0+554 (normal left inverted right x axis y axis) 309mm x 173mm
# DP-1 connected 1920x1080+3200+0 (normal left inverted right x axis y axis) 531mm x 299mm
# HDMI-1 disconnected (normal left inverted right x axis y axis)
# HDMI-2 connected 1920x1080+1280+0 (normal left inverted right x axis y axis) 531mm x 299mm

# Two monitors (with player)
# eDP-1 connected primary 1280x720+0+554 (normal left inverted right x axis y axis) 309mm x 173mm
# DP-1 disconnected 1920x1080+3200+0 (normal left inverted right x axis y axis) 0mm x 0mm
# HDMI-1 disconnected (normal left inverted right x axis y axis)
# HDMI-2 connected 1920x1080+1280+0 (normal left inverted right x axis y axis) 531mm x 299mm

# One monitor (solo)
# eDP-1 connected primary 1368x768+0+0 (normal left inverted right x axis y axis) 309mm x 173mm
# DP-1 disconnected (normal left inverted right x axis y axis)
# HDMI-1 disconnected (normal left inverted right x axis y axis)
# HDMI-2 disconnected (normal left inverted right x axis y axis)

export DISPLAY=:0
export XAUTHORITY=/home/ghislain/.Xauthority

if xrandr | grep "^HDMI-1-0 connected"; then
    if xrandr | grep "^DP-1 connected"; then
        echo "ondock" | tee -a $LOG
        /home/ghislain/.screenlayout/default_layout.sh
    else
        echo "with player" | tee -a $LOG
        /home/ghislain/.screenlayout/default_layout.sh
    fi
else
    echo "solo" | tee -a $LOG
    /home/ghislain/.screenlayout/solo.sh
fi

# /usr/bin/Esetroot /home/ghislain/Images/lock.png
