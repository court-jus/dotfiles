#!/bin/bash

updateClock()
	{
	echo "0 widget_tell mystatusbar clock text "    " `date +\"%Y/%m/%d %H:%M\"`" | awesome-client
	}

while true; do 
	updateClock
	sleep 10;
done
