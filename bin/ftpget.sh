#!/bin/bash

IPSERVER=127.0.0.1
PORT=21
USER=onelink
PASS=onelink
DOSSIERDISTANT=res
DOSSIERLOCAL=/tmp/
FICHIEROK=OK
FICHIERSCIBLE=HPR
DELAY=30
SUPPRIMERDISTANTS=1
LFTP=lftp

cd $DOSSIERLOCAL

while true; do
    old_IFS=$IFS     # sauvegarde du séparateur de champ  
    IFS=$'\n'     # nouveau séparateur de champ, le caractère fin de ligne  
    # Connexion au serveur et listing des fichiers OK
    for fichierok in `$LFTP -p $PORT -u $USER,$PASS $IPSERVER -e "cls -1 $DOSSIERDISTANT/*.$FICHIEROK; quit"` ; do
        # Pour chaque fichier OK, recalculer le nom du fichier HPR correspondant
        fichiercible=${fichierok/$FICHIEROK/$FICHIERSCIBLE}
        echo "Récupération fichier $fichiercible"
        # Récupération
        if $LFTP -p $PORT -u $USER,$PASS $IPSERVER -e "get $fichiercible; quit" ; then
            echo "OK"
            # Si tout va bien et qu'on doit supprimer ben on le fait
            if [ $SUPPRIMERDISTANTS == 1 ]; then
                echo "Suppression fichier $fichiercible et $fichierok"
                $LFTP -p $PORT -u $USER,$PASS $IPSERVER -e "rm $fichiercible; rm $fichierok ; quit"
            fi
        else
            echo "KO"
        fi
    done
    IFS=$old_IFS     # rétablissement du séparateur de champ par défaut
    sleep $DELAY
done
