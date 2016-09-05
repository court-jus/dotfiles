#!/bin/bash

DIR=${HOME}/share/backgrounds/trialscreen/RealThreeHeads/resized
DELAY=$1

while true
    do
    for file in ${DIR}/*
        do
        /usr/bin/Esetroot "${file}"
        sleep ${DELAY}
        done
    done
