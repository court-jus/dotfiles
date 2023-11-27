#!/bin/bash

echo "Using Laguiole instead of unsplash"
#Esetroot ~/Pictures/mars_cropped_scaled.jpg
Esetroot ~/Pictures/laguiole3.jpg
exit 0

keyword=abstract
width=5120
height=1280

URL=https://source.unsplash.com/random/${width}x${height}/?${keyword}

URL1=https://source.unsplash.com/random/1368x768/?${keyword}
URL2=https://source.unsplash.com/random/2560x1080/?${keyword}
URL3=https://source.unsplash.com/random/1920x1080/?${keyword}

# TMPDIR=$(mktemp -d)
TMPDIR="/tmp/unsplash"
mkdir -p ${TMPDIR}

cd ${TMPDIR}
#wget -O url1.jpg ${URL1}
#wget -O url2.jpg ${URL2}
#wget -O url3.jpg ${URL3}
wget -O out.jpg ${URL}
convert out.jpg out.png

#convert url3.jpg -border 0x208 url4.jpg
#convert url1.jpg -border 0x600 url4.jpg
#montage -mode concatenate -tile 3x1 url4.jpg url3.jpg url2.jpg out.jpg
# montage -mode concatenate -tile 2x1 url4.jpg url2.jpg out.jpg
# convert -size 5120x1136 -page +0+0 out.jpg -colorspace gray -fill 'rgb(0,1,50)' -tint 255 -page +50+258 /home/ghislain/Images/cenareo/logo_small.png  -page +1330+50 /home/ghislain/Images/cenareo/logo_small.png  -page +3250+50 /home/ghislain/Images/cenareo/logo_small.png -layers flatten out.png

Esetroot out.jpg
