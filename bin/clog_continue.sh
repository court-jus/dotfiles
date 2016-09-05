#!/bin/bash

filename=$1
shift
args=$@

echo "#### on continue ?? ####" >> $filename

grep "\.\. \<[0-9a-f]\{40\}\>" $filename | awk '{print $2}' > dejaclog

git show --no-patch \
         --pretty=format:"- %s%n  %b%n  .. %H%n%n" \
         $(git log --no-merges $args --format=%H | grep -v -f dejaclog) |\
    sed -E 's@#([0-9]{5})@`#\1 <http://claritick.clarisys.fr/ticket/modify/\1>`_@g' |\
    sed -E 's@#([0-9]{1,4})@`#\1 <http://gitlab.clarisys.lan/mca/mca/issues/\1>`_@g'|\
    sed -e "s@^[^- ]@  \0@" >> $filename



