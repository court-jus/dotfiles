#!/bin/sh

echo "##################################"
echo "######### DEBUT BACKUP ###########"
echo "##################################"
date
echo "##################################"

USER="gl"
DIRECTORIES="Clarisys bin src public_html Backups"

ROOT="/home/${USER}"
ABS_DIRS=""
for dir in ${DIRECTORIES}; do
  ABS_DIRS="$ABS_DIRS ${ROOT}/${dir}"
done

dpkg --get-selections > ${ROOT}/Backups/liste_paquets_installes

SRV="10.31.254.7"
/usr/bin/rsync -a --recursive -v --exclude-from=${HOME}/etc/backup/exclude_first.lst --include-from=${HOME}/etc/backup/include.lst --exclude-from=${HOME}/etc/backup/exclude.lst ${HOME}/ rsync://${SRV}/public/${USER}


echo "##################################"
echo "########## FIN  BACKUP ###########"
echo "##################################"
