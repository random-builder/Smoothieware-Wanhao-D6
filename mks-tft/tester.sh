#!/usr/bin/ckermit +

# panel debug script

# $port
set line /dev/ttyUSB0
if fail exit 1 "invalid port"

# $rate
set speed 250000
if fail exit 1 "invalid rate"
set serial 8n1
set flow-control none
set carrier-watch off
set modem type none

# monitor progress
set input echo on
set term echo local
set term cr-display crlf

connect
