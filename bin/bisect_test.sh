#!/bin/bash

sleep 5

wd=$(pwd)
cd /home/gl/src/ikare/ikare-meta/docker/compose2/

docker-compose kill api
docker-compose rm -f api
docker-compose up -d --force-recreate api
sleep 5
testapi.py $(docker_ip compose2_api_1)

cd $wd
