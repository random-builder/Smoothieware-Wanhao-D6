#!/usr/bin/ckermit +

# motion debug tester

# $port
set line /dev/ttyACM0

# $rate
set speed 250000
set serial 8n1
set flow-control none
set carrier-watch off
set modem type none

# 
set input echo on

# home
lineout "G90"
input 30 "ok"

lineout "G28 X"
input 30 "ok"

# move axis x
while true {
    lineout "G1 X010 F7200"
    input 30 "ok"
    lineout "G1 X190 F7200"
    input 30 "ok"
}
