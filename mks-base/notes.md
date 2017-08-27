
### power

mks-base board will be live when powered over usb only

```
lsusb
...
Bus 001 Device 098: ID 1d50:6015 OpenMoko, Inc. Smoothieboard
...
```

mks-tft board will work only on 5V provided by mks-base,
which is converting 24V to 5V, and will not work on usb power only.

must match mks-tft and mks-base uart0 baud rate

board uses uni-directional 3.3v -> 5v and 5v-> 3.3v buffers
