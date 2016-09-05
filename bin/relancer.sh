#!/bin/bash

continuer=1
tmpfile=`mktemp -t`

while [ $continuer -eq 1 ] ; do
    if dialog --menu "Que faire ?" 40 80 40 d "Reload DJSERV" r "Restart DJSERV" a "Restart apache" l "Log de django" p "Log de apache" s "Log de djserv" 2> $tmpfile ; then
        ans=`cat $tmpfile`
        if [ "$ans" == "d" ] ; then
            sudo /etc/init.d/djserv reload
        elif [ "$ans" == "r" ] ; then
            sudo /etc/init.d/djserv restart
        elif [ "$ans" == "a" ] ; then
            sudo /etc/init.d/apache2 restart
        elif [ "$ans" == "l" ] ; then
            less $HOME/logs/django.log
        elif [ "$ans" == "p" ] ; then
            sudo less /var/log/apache2/error.log
        elif [ "$ans" == "s" ] ; then
            less $HOME/logs/server.log
        fi
    else
        break;
    fi
    rm -f $tmpfile
done

