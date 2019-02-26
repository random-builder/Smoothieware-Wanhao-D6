#!/usr/bin/kermit +

# smooth reboot script

# $port
set line \%1
if fail exit 1 "invalid port"

# $rate
set speed \%2
set serial 8n1
set flow-control none
set carrier-watch off
set modem type none

# monitor progress
set input echo on

# issue reset
input 10 "ok"
lineout "reset"
input 10 "booting"

# wait for reboot
sleep 10

exit 0
