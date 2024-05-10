#!/bin/bash

file=$1

TMPDIR="/tmp/memev"
mkdir -p ${TMPDIR}

cd ${TMPDIR} || exit

ffmpeg -i "${file}" \
  -filter_complex "\
[0]crop=iw/3:ih/2:0:0[tl];\
[0]crop=iw/3:ih/2:iw/3:0[tc];\
[0]crop=iw/3:ih/2:iw/3+iw/3:0[tr];\
[0]crop=iw/3:ih/2:0:ih/2[bl];\
[0]crop=iw/3:ih/2:iw/3:ih/2[bc];\
[0]crop=iw/3:ih/2:iw/3+iw/3:ih/2[br]" \
  -map "[tl]" topleft.mp4 \
  -map "[tc]" topcenter.mp4 \
  -map "[tr]" topright.mp4 \
  -map "[bl]" botleft.mp4 \
  -map "[bc]" botcenter.mp4 \
  -map "[br]" botright.mp4
