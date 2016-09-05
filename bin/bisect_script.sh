#!/bin/bash

cd /home/gl/src/mca
. .local/bin/activate
# make clean
cd /home/gl/src/mca/webui
. ./env.sh
npm install
bower install
grunt build
cd /home/gl/src/mca
python manage.py supervisor restart www
