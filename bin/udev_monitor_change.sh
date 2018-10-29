#!/bin/bash

# /etc/udev/rules.d/80-monitor.rules contains :
# ACTION=="change", SUBSYSTEM=="drm", RUN+="/home/ghislain/bin/udev_monitor_change.sh"

export DISPLAY=:0
export XAUTHORITY=/home/ghislain/.Xauthority

if xrandr | grep "HDMI-2 connected"; then
    echo "ondock" | tee -a $LOG
    /home/ghislain/.screenlayout/default_layout.sh
else
    echo "solo" | tee -a $LOG
    /home/ghislain/.screenlayout/solo.sh
fi

/usr/bin/Esetroot /home/ghislain/Images/lock.png
