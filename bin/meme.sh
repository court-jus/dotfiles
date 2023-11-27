#!/bin/bash

keyword=$1
text=$2
color=$3
width=1920
height=1080

URL=https://source.unsplash.com/random/${width}x${height}/?${keyword}

TMPDIR="/tmp/meme"
tmpname="tmp.jpg"
outputname="$(date +%s).jpg"
mkdir -p ${TMPDIR}

cd ${TMPDIR}
wget -O out.jpg ${URL}
convert out.jpg -gravity NorthWest -stroke black -strokewidth 2 -fill white -density 90 -pointsize 92 -annotate +50+150 "${text}" "${tmpname}"
rm -f out.jpg
if [ "${color}" != "" ]; then
    convert -size 1920x1080 -page +0+0 "${tmpname}" -colorspace gray -fill "${color}" -tint 150 -page +0+0 -layers flatten "${outputname}"
else
    mv "${tmpname}" "${outputname}"
fi
rm -f "${tmpname}"
eog "${outputname}"
#convert out.jpg out.png

#convert url3.jpg -border 0x208 url4.jpg
#convert url1.jpg -border 0x600 url4.jpg
#montage -mode concatenate -tile 3x1 url4.jpg url3.jpg url2.jpg out.jpg
# montage -mode concatenate -tile 2x1 url4.jpg url2.jpg out.jpg
# convert -size 5120x1136 -page +0+0 out.jpg -colorspace gray -fill 'rgb(0,1,50)' -tint 255 -page +50+258 /home/ghislain/Images/cenareo/logo_small.png  -page +1330+50 /home/ghislain/Images/cenareo/logo_small.png  -page +3250+50 /home/ghislain/Images/cenareo/logo_small.png -layers flatten out.png
