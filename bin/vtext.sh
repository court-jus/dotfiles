#!/bin/bash

file=$1
text=$2
color=$3
size=$4

TMPDIR="/tmp/memev"
outputname="$(date +%s).mp4"
mkdir -p ${TMPDIR}

cd ${TMPDIR} || exit
if [ -z "${color}" ]
then
    color=white
fi

if [ -z "${size}" ]
then
    size=50
fi

if ! ffmpeg -y -i "${file}" -vf "drawtext=text='${text}':fontfile=/path/to/font.ttf:fontsize=${size}:fontcolor=${color}:x=100:y=100" -codec:a copy "${outputname}" > /dev/null 2>&1
then
    echo "FFMPEG text error"
    exit
fi

echo "${TMPDIR}/${outputname}"
