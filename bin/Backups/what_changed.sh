#!/bin/bash

###############################################################################
#                                What Changed ?
###############################################################################
#
# About
# =====
#
# The purpose of this script is to keep a track of what files changed during
# an operation.
#
# For example : you hack your Xorg setting a lot, install new packages, remove
# others because you are trying a new driver
#
# Then you want to roll back and all you have saved is your xorg.conf. Damn
# what where this packages I removed ?
#
# Dependies
# =========
#
# dar
#
###############################################################################

before()
    {
    cd "$1"
    rm -rf .what_changed
    mkdir .what_changed
    dar -c - -P .what_changed -G .what_changed/before_catalog > /dev/null
    }

after()
    {
    cd "$1"
    dar -A .what_changed/before_catalog -c - -P .what_changed -G .what_changed/after_catalog > /dev/null
    }

WHAT="$1"
FOLDER="$2"

if [ "$FOLDER" == "" ]; then
    FOLDER=$PWD
fi

if [ "$WHAT" == "before" ] ; then
    before "$FOLDER"
elif [ "$WHAT" == "after" ] ; then
    after "$FOLDER"
else
    echo "WHAT ?"
fi
