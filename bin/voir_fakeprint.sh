#!/bin/bash

if [ `cat /tmp/fakeprint.log | wc -l` -eq 0 ] ; then
    zenity --info --text "rien"
    exit
fi

echo -n > /tmp/fakeprint2.log
for file in `cat /tmp/fakeprint.log` ; do
    kpdf "$file"
    if zenity --question --text "Supprimer ce fichier ?" ; then
        rm -f "$file"
    else
        echo "$file" >> /tmp/fakeprint2.log
    fi
done

rm -f /tmp/fakeprint.log
mv /tmp/fakeprint2.log /tmp/fakeprint.log
