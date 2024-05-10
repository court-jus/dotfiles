#!/bin/bash

file=$1
width=$2
height=$3

TMPDIR="/tmp/memev"
outputname="$(date +%s).mp4"
mkdir -p ${TMPDIR}
vwidth=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=s=x:p=0 "$file")
vheight=$(ffprobe -v error -select_streams v:0 -show_entries stream=width -of csv=s=x:p=0 "$file")
x=$(( (vwidth - width) / 2 ))
y=$(( (vheight - height) / 2 ))

echo "crop=${width}:${height}:${x}:${y}"

cd ${TMPDIR} || exit
if ! ffmpeg -i "${file}" -filter:v "crop=${width}:${height}:${x}:${y}" "${outputname}" > /dev/null 2>&1
then
    echo "FFMPEG colorize error"
fi

echo "${TMPDIR}/${outputname}"
