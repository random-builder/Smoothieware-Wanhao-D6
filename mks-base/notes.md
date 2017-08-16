
### power

mks-base board will show live when powered over usb only

```
lsusb
...
Bus 001 Device 098: ID 1d50:6015 OpenMoko, Inc. Smoothieboard
...
```

mks-tft board will work only on 5V provided by mks-base,
which is converting 24V to 5V, and will not work on usb power only.
