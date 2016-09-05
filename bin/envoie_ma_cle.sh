#!/bin/bash

if [ $# -lt 2 ] ; then
    echo "usage : $0 IP PASS"
    exit
fi

ip=$1
pass=$2

sshpass -p"$pass" ssh-copy-id -i ~/.ssh/id_rsa.pub root@$ip
