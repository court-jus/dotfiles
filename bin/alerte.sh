#!/bin/bash

echo "DISPLAY=:0 zenity --info --title Alerte --text $1" | at $2
