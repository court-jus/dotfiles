#!/bin/bash

keyword=$1
#width=1920
#height=1080
api_key=$(cat ~/.config/pixabay_api_key)

URL="https://pixabay.com/api/videos/?key=${api_key}&q=${keyword}"

TMPDIR="/tmp/memev"
mkdir -p ${TMPDIR}

cd ${TMPDIR} || exit
if ! wget -O out.json "${URL}" > /dev/null 2>&1
then
    echo "Error downloading ${URL}"
    exit
fi

number_items=$(jq ".hits|length" out.json)
# RANDOM is between 0 and 32767
chosen=$(( RANDOM / (32767 / number_items) ))
VIDEO_URL=$(jq -r ".hits[${chosen}].videos.medium.url" out.json)
rm -f tmp.mp4
if ! wget -O tmp.mp4 "${VIDEO_URL}" > /dev/null 2>&1
then
    echo "Error downloading ${VIDEO_URL}"
    exit
fi
echo "${TMPDIR}/tmp.mp4"
