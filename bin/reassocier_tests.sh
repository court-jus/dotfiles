#!/bin/sh

automate=$1
existant=$2
manquant=$3

PG="/usr/local/pg84/bin/psql -h 127.0.0.1 dump_lorient auto"

id_existant=`$PG "select id from testbio where code = '$existant'"`
id_manquant=`$PG "select id from testbio where code = '$manquant'"`

echo "Remplacement de $manquant($id_manquant) par $existant($id_existant)"

PG=echo

$PG "update dem_auto_test set testbio=$id_existant where testbio=$id_manquant ; update resu_auto set testbio=$id_existant where testbio=$id_manquant; update resultat set testbio=$id_existant, test=$existant where testbio=$id_manquant; update resultat set sous_test = $existant where sous_test = $manquant"
