#!/bin/bash

ROUTE="/sbin/route"
GREP="/bin/grep"
AWK="/usr/bin/awk"
LOG="/var/log/vpnHEH.log"



logger() {
echo "$1" >> ${LOG}
}

> ${LOG}
gateway=`${ROUTE} -n | ${GREP} ppp0 |${GREP}  '10.0.0.0' | ${AWK} '{print $2}'`
echo ${gateway} >> ${LOG}
logger "Suppression route 172.0.0.0/8"
${ROUTE} del -net 172.0.0.0/8 >> ${LOG} 2>&1
logger "Suppression route 192.168.0.0/16"
${ROUTE} del -net 192.168.0.0/16  >> ${LOG} >> ${LOG} 2>&1
logger "Suppression route 10.0.0.0/8"
${ROUTE} del -net 10.0.0.0/8  >> ${LOG} 2>&1
logger "Ajout route 10.21.24.0/24 via ${gateway}"
${ROUTE} add -net 10.21.24.0/24 gw ${gateway} >> ${LOG} 2>&1

