#!/bin/bash

file=$1
color=$2

TMPDIR="/tmp/memev"
outputname="$(date +%s).mp4"
mkdir -p ${TMPDIR}
vsize=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$file")
cd ${TMPDIR} || exit
if [ -n "${color}" ]
then
    if ! ffmpeg -y -i "${file}" -f lavfi -i "color=${color}:s=${vsize}" -filter_complex "blend=shortest=1:all_mode=overlay:all_opacity=0.7" "${outputname}" > /dev/null 2>&1
    then
        echo "FFMPEG colorize error"
        exit 1
    fi
fi

echo "${TMPDIR}/${outputname}"
