#!/usr/bin/env python

print """find . -name "* *" -exec echo "\"{}\"" \; > do.sh"""

fh = open("do.sh", "r")
lines = fh.read().split('\n')
fh.close()

fh2 = open("do2.sh", "w")
for l in lines:
    if l:
        fh2.write("mv %s %s\n" % (l, l.replace(' ', '%20')))
fh2.close()

