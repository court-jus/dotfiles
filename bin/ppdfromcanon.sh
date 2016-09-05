#!/bin/bash

cat "$1" | ~/bin/convertctrlm.sh | foomatic-ppd-options - | cut -d\; -f1
