#!/bin/bash

MANAGE=${HOME}/bin/manage_vm

# Stop if any VM is running
$MANAGE <<<3
sleep 1
# Switch to snapshot
$MANAGE <<<6

# New VM
$MANAGE <<<1

# Wait for it to be running
sleep 60
$MANAGE <<<4 | grep "VM nightly is up and running" || (echo "It didn't work" ; exit)

ssh mca@nightly "/home/mca/MCA3/night.sh"

# Eteindre la VM
sleep 5
ssh mca@nightly "sudo /sbin/shutdown -h now"
sleep 5
$MANAGE <<<3
