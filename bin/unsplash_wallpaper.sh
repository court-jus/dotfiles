#!/bin/bash

URL1=https://source.unsplash.com/random/1920x1080/?water
URL2=https://source.unsplash.com/random/1920x1080/?forest
URL3=https://source.unsplash.com/random/1280x720/?sun

# TMPDIR=$(mktemp -d)
TMPDIR="/tmp/unsplash"
mkdir -p ${TMPDIR}

cd ${TMPDIR}
wget -O url1.jpg ${URL1}
wget -O url2.jpg ${URL2}
wget -O url3.jpg ${URL3}

convert url3.jpg -border 0x208 url4.jpg
montage -mode concatenate -tile 3x1 url4.jpg url2.jpg url1.jpg out.jpg

Esetroot out.jpg
