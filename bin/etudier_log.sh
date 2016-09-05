#!/bin/bash

what=$1
rdeb=$2
if [ $# -gt 2 ] ; then
    rfin=$3
else
    rfin=$rdeb
fi

for r in `seq $rdeb $rfin` ; do 
    rnext=$[ r + 1 ]

    (echo $r:$rnext ; svn diff -r $r:$rnext $what) | less --quit-if-one-screen
    if [ $r -ne $rfin ]; then
        read
    fi
done
