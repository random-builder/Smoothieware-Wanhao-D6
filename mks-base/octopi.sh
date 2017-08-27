#!/bin/bash

# mks-base firmware update via ssh

location=$(dirname "$0")

HOST="octopi2"
PORT="/dev/ttyACM0"
RATE="115200"
PATH_LOC="$location"
PATH_REM="/home/pi/smooth"

echo "### copy file"
ssh "$HOST" "rm -rf $PATH_REM/*"
ssh "$HOST" "mkdir -p $PATH_REM/source"
scp "$PATH_LOC/mks.sh" "$HOST:$PATH_REM/"
scp "$PATH_LOC/reset.sh" "$HOST:$PATH_REM/"
scp "$PATH_LOC/source"/* "$HOST:$PATH_REM/source/" 

echo "### run update"
ssh "$HOST" "$PATH_REM/mks.sh"

echo "### issue reset"
ssh "$HOST" "$PATH_REM/reset.sh $PORT $RATE"

echo "### ready"
