#!/bin/bash

[ $# -ne 1 ] && (echo "Preciser le nom de la bdd" ; exit 1)
pg_dump -O -x -h bingo -U auto -N dvpt -N archive -s "$1" > "$1".sqlschema
