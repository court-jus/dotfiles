#!/bin/bash

file=$1
duration=$2

TMPDIR="/tmp/memev"
outputname="$(date +%s).mp4"
mkdir -p ${TMPDIR}

cd ${TMPDIR} || exit
if ! ffmpeg -y -ss "00:00:00" -t "00:00:${duration}" -i "${file}" -acodec copy -vcodec copy -async 1 "${outputname}" > /dev/null 2>&1
then
    echo "FFMPEG trim error"
fi

echo "${TMPDIR}/${outputname}"
