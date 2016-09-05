#!/bin/bash

if [ $# != 1 ] ; then
    echo "NUMERO DE LIGNE !"
    exit
fi

nligne=$1
cp ~/.ssh/known_hosts ~/.ssh/known_hosts.bak
awk 'NR!='"$nligne"' {print}' /home/gl/.ssh/known_hosts.bak > ~/.ssh/known_hosts

