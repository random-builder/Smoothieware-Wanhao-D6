<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td><img src="example/1-logo.jpg?raw=true" align="right" alt="logo" /></td>
<td><img src="example/2-iconlogo.jpg?raw=true" align="right" alt="icon logo" /></td>
<td><img src="example/3-tools.jpg?raw=true" align="right" alt="tools" /></td>
<td><img src="example/4-tools-more.jpg?raw=true" align="right" alt="tools more" /></td>
<td><img src="example/5-set.jpg?raw=true" align="right" alt="set" /></td>
</tr>
</table>

### `mks.sh` firmware loader

allows to prepare MKS-TFT sd-disk with firmware

### `mks.sh` icon generator

allows to generate any of MKS-TFT icons
from an svg glyph and a text title,
use primarily for custom function buttons

glyph origin: http://glyph.smarticons.co/

### how `mks.sh` works

the script uses single template `arkon.svg`
and button descriptor table `icon_conf`,
so for every entry `button`, 
script will generate `button.svg` 
then convert `svg->png` to `button.png`
and finally `png->bin` to `bmp_button.bin`

### how to use `arkon.svg` and `mks.sh` 

* clone this repository
* adjust font/background color in `arkon.svg` 
* add/change `icon_conf`: button/icon_name/icon_text in `mks.sh`
* attach to computer `fat32` sd-card  with label `MKS-TFT` for upload 
* execute `mks.sh` from this folder and review results in `source` folder
* place sd-card into MKS-TFT, press reset, wait for re-flash and review icons

### additional `mks.sh` vector images

these are stand alone images processed by the script:
* `logo.svg` : boot splash logo
* `iconlogo.svg` : home menu icon

### `mks.sh` script requirements

install software
* gimp
* inkscape

install gimp plugins
* `exportCBin.py` : https://github.com/random-builder/gimp-plugin-exp-c 

install inkscape plugins
* none
