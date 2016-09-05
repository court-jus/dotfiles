#!/bin/bash

script_bpm=/home/gl/bpm
IP=$1

scp ${script_bpm} mca@${IP}:/tmp/

ssh.real -A mca@${IP} /tmp/bpm

rsync -rzP mca@${IP}:mca3_parapm*tar /home/gl/bpm_archives/
