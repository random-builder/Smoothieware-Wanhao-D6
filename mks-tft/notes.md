
### icon format

Image2LCD settings:
* output file type: binary(*.bin)
* scan mode: horizontal scan
* bits pixel: 16-bit TrueColor
* max width and height: 
* 320x240 for boot logo screen 
* 320x135 for menu logo screen 
* 78x104 pixels for regular buttons

### gimp export for Image2LCD 

export as: *.ico

options: 24 bit

### gimp direct binary export

install gimp plugin: https://github.com/random-builder/gimp-plugin-exp-c

export as: binary image data: 16bit (R5-G6-B5)

### serial debug via AUX-1

* usb-to-seriala convertor:
https://www.amazon.com/Armorview-PL2303HX-Cable-Module-Converter/dp/B008AGDTA4

* kermit: try baud rate 230400 instead of 250000

* wiring:
tft     usb/serial
-------------------
TXD --- RXD (white)
RXD --- TXD (green)
GND --- GND (black)
5V0 --- 5V0 (red)
