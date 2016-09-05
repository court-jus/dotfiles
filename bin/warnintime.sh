#!/bin/bash

delaytime=`xclip -o | sed -e "s/h/*60/g" -e "s/d/*24*60/g" -e "s/m/*1/g" -e "s/s/*0/g" -e "s/ /+/g" | bc | sed -e "s/$/ minutes/"`

/home/gl/bin/alerte.sh plop "now + $delaytime"
