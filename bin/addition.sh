#!/bin/bash

total=0

while read ligne; do
    total=$[ total + ligne ]
done

echo $total
