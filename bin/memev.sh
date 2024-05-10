#!/bin/bash

keyword=$1
text=$2
color=$3
#width=1920
#height=1080
api_key=$(cat ~/.config/pixabay_api_key)

URL="https://pixabay.com/api/videos/?key=${api_key}&q=${keyword}"

TMPDIR="/tmp/memev"
outputname="$(date +%s).mp4"
mkdir -p ${TMPDIR}

cd ${TMPDIR} || exit
if ! wget -O out.json "${URL}"
then
    echo "Error downloading ${URL}"
    exit
fi

number_items=$(jq ".hits|length" out.json)
echo "${number_items} videos available"
# RANDOM is between 0 and 32767
chosen=$(( RANDOM / (32767 / number_items) ))
echo "${chosen} chosen"
VIDEO_URL=$(jq -r ".hits[${chosen}].videos.medium.url" out.json)
echo "Download ${VIDEO_URL}"
rm -f tmp.mp4
if ! wget -O tmp.mp4 "${VIDEO_URL}"
then
    echo "Error downloading ${VIDEO_URL}"
    exit
fi
echo "${TMPDIR}/tmp.mp4 downloaded"
cp tmp.mp4 colorized.mp4
if [ -n "${color}" ]
then
    rm -f colorized.mp4
    if ! ffmpeg -i tmp.mp4 -f lavfi -i "color=${color}:s=1280x720" -filter_complex "blend=shortest=1:all_mode=overlay:all_opacity=0.7" colorized.mp4
    then
        echo "FFMPEG colorize error"
    fi
fi

if ! ffmpeg -i colorized.mp4 -vf "drawtext=text='${text}':fontfile=/path/to/font.ttf:fontsize=50:fontcolor=white:x=100:y=100" -codec:a copy "${outputname}"
then
    echo "FFMPEG error"
    exit
fi
echo "Text added: ${outputname}"
