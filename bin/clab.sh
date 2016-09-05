#!/bin/sh

. ~/.bashrc

#MAINPATH=/home/gl/src/clarisys/
MAINPATH=/home/gl/src/clarisys/clarilabprod/
echo "



Utilisation de $MAINPATH




"
CLABPATH=$MAINPATH/clarilab/
NAMESERVICE="localhost:1080"

if [ ! "$1" ]; then
 PARAMS="--server=localhost:2810 --site=clarisys"
 OPTS=""
elif [ "$1" = "demo" ]; then
 PARAMS="--server=192.168.1.80:2810 --site=clarisys --no-preload"
 NAMESERVICE="192.168.1.15:1180"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
 OPTS=" $2 $3 $4"
 echo "$1"
elif [ "$1" = "cbm2" ]; then
 PARAMS="--server=195.3.1.61:2811 --site=clarisys"
 NAMESERVICE="195.3.1.61:1080"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
 OPTS=" $2 $3 $4"
 echo "$1"
elif [ "$1" = "cbm" ]; then
 PARAMS="--server=195.3.1.61:2811 --site=clarisys"
 NAMESERVICE="195.3.1.61:1080"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
 OPTS=" $2 $3 $4"
 echo "$1"
elif [ "$1" = "hexa" ]; then
 PARAMS="--server=10.53.32.61:2810 --site=clarisys"
 NAMESERVICE="10.53.32.61:1080"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
 OPTS=" $2 $3 $4"
 echo "$1"
elif [ "$1" = "gl" ]; then
 PARAMS="--server=192.168.1.9:2810 --site=clarisys --barcodeNameService=127.0.0.1:1050"
 NAMESERVICE="192.168.1.27:1080"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
 OPTS=" $2 $3 $4"
 echo "$1"
elif [ "$1" = "prod" ]; then
 PARAMS="--server=127.0.0.1:2810 --site=clarisys --barcodeNameService=127.0.0.1:1050"
 NAMESERVICE="192.168.1.27:1080"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
 OPTS=" $2 $3 $4"
 echo "$1"
elif [ "$1" = "prod2" ]; then
 PARAMS="--server=127.0.0.1:2811 --site=clarisys --debug"
# NAMESERVICE="10.72.47.254:1080"
# NAMESERVICE="192.168.1.80:1090"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
# OPTS="--barcodeNameService 192.168.1.27:1050 $2 $3 $4"
 echo "$1"
elif [ "$1" = "labomaine-test" ]; then
 PARAMS="--server=10.72.3.10:2825 --site=clarisys"
 NAMESERVICE="10.72.3.10:8080"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
 OPTS="$2 $3 $4"
 echo "labomaine-test"
elif [ "$1" = "chantal" ]; then
 PARAMS="--server=192.168.1.80:2910 --site=clarisys"
 NAMESERVICE="192.168.1.80:1090"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
 OPTS="$2 $3 $4"
 echo "chantal"
elif [ "$1" = "labomaine" ]; then
 PARAMS="--server=10.72.3.20:2810 --site=clarisys --nameService=10.72.3.20:1080"
 NAMESERVICE="10.72.3.20:1080"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
 OPTS="$2 $3 $4"
 echo "labomaine"
elif [ "$1" = "labomaine2" ]; then
 PARAMS="--server=10.72.3.40:2839 --site=clarisys --nameService=10.72.3.20:1080"
 NAMESERVICE="10.72.3.20:1080"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
 OPTS="$2 $3 $4"
 echo "labomaine2"
elif [ "$1" = "labomaine3" ]; then
 PARAMS="--server=10.72.3.20:2827 --site=clarisys --nameService=10.72.3.20:1080"
 NAMESERVICE="10.72.3.20:1080"
 export PYTHONPATH=$MAINPATH:$CLABPATH
 CLABPATH=$CLABPATH
 OPTS="$2 $3 $4"
 echo "labomaine2"
else
 PARAMS="--server=localhost:2810 --site=clarisys"
 OPTS=$@
fi

echo "nameService: $NAMESERVICE"
python ${CLABPATH}/clarilab.py --nameService ${NAMESERVICE} $PARAMS $OPTS 
#ORBtraceLevel=20 python ${CLABPATH}/clarilab.py --nameService ${NAMESERVICE} $PARAMS $OPTS 

