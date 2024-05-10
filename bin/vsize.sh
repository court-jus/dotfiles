#!/bin/bash

file=$1

vsize=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$file")
echo "${vsize}"