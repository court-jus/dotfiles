#!/bin/bash

if ! /sbin/route -n | grep "^172" ; then
    LANG=C firefox "https://portail-hcl.chu-lyon.fr/my.logon.php3?username=ventrech" &
fi


read -p "Appuyer pour continuer"

if /sbin/route -n | grep "^172" ; then
    sudo $HOME/bin/vpnHEH.sh
else
    echo "Ca n'a pas marche ?"
fi
