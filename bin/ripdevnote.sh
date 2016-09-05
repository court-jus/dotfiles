#!/bin/bash

RIPDEV=${HOME}/bin/ripdev.sh

NEWNOTE=$(zenity --title='RIPDEV' --text='Saisir une nouvelle note' --entry)

if [ "$NEWNOTE" != "" ]; then
    $RIPDEV --note="$NEWNOTE"
fi
