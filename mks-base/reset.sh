#!/usr/bin/kermit +

# smooth reboot script

# $PORT
SET LINE \%1
IF FAIL EXIT 1 "invalid port"

# $RATE
SET SPEED \%2
SET SERIAL 8N1
SET FLOW-CONTROL NONE
SET CARRIER-WATCH OFF
SET MODEM TYPE NONE

INPUT 5 "ok"

LINEOUT "reset"

INPUT 5 "booting"

SLEEP 5

EXIT
