#!/bin/bash

MAINSCRIPT=/home/gl/bin/Backups/what_changed.sh

${MAINSCRIPT} before /bin
${MAINSCRIPT} before /etc
${MAINSCRIPT} before /boot
${MAINSCRIPT} before /root
${MAINSCRIPT} before /sbin
${MAINSCRIPT} before /usr
${MAINSCRIPT} before /var
${MAINSCRIPT} before /lib
${MAINSCRIPT} before /opt
${MAINSCRIPT} before /selinux
${MAINSCRIPT} before /srv
${MAINSCRIPT} before /home
