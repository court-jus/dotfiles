#!/bin/bash

tmp=`mktemp -t fakeprint.pdf.XXXXXXXXXXXXX`
logfile=/tmp/fakeprint.log
cat > $tmp
echo $tmp >> $logfile
