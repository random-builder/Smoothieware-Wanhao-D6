#!/bin/bash

# mks-tft firmware generator

set -e

# sd-card partition label
readonly label="MKS-TFT"

# sd-card mount folder
readonly point="/tmp/$label"

# firmware archive download "TFT28_32_v3.0.3 Release file.zip"
readonly mks_url="https://github.com/random-builder/MKS-TFT/raw/master/Firmware/TFT28_32_v3.0.3%20Release%20file.zip"

# resource folder inside archive
readonly mks_profile="TFT28_32_v3.0.3 Release file/Examples/Classic_En_Red"

# svg icon glyph library
readonly glyph_url="https://github.com/random-builder/glyph-iconset/archive/master.zip"

# resource folder inside archive
readonly glyph_profile="glyph-iconset-master"

# button, icon name and icon text configuration
readonly icon_conf=(
#   button      icon_name                           icon_text
    "more       si-glyph-bolt                       MORE"   # in 'menu->tools'
#
#    "custom1    si-glyph-fire                       ABORT"   # in 'menu->more'    "custom1    si-glyph-fire                       ABORT"   # in 'menu->more'
    "custom1    si-glyph-arrow-circle-rycycle       RESET"   # in 'menu->more'
    "custom2    si-glyph-layout-2                   STOP"    # in 'menu->more'
    "custom3    si-glyph-circle-triangle-right      PLAY"    # in 'menu->more'
    "custom4    si-glyph-two-arrow-down             BED"     # in 'menu->more'
    "custom5    si-glyph-thermometer                LO"      # in 'menu->more'
    "custom6    si-glyph-thermometer                HI"      # in 'menu->more'
    "custom7    si-glyph-jump-page-up-down          LEVEL"   # in 'menu->more'
#    
    "function1  si-glyph-turn-off                   X"       # in 'menu->home'
    "function2  si-glyph-fire                       FUN2"    # ???
    "morefunc1  si-glyph-dice-1                     MOFU1"   # ???
    "morefunc2  si-glyph-dice-2                     MOFU2"   # ???
    "morefunc3  si-glyph-dice-3                     MOFU3"	 # ???
    "morefunc4  si-glyph-dice-4                     MOFU4"	 # ???
    "morefunc5  si-glyph-dice-5                     MOFU5"	 # ???
    "morefunc6  si-glyph-dice-6                     MOFU6"	 # ???
)

# button template file name
readonly template="arkon"

# generate icons from vector template
make_icons() {
    local base="$folder/source/mks_pic"
    local button icon_name icon_text
    local conf icon_path source target
    for conf in "${icon_conf[@]}" ; do
        conf=($conf)
        button=${conf[0]}
        icon_name=${conf[1]}
        icon_text=${conf[2]}
        icon_path="../../archive/$glyph_profile/sprite/sprite.svg#$icon_name"
        source="$base/$template.svg"
        target="$base/$button.svg"
        echo "# generate $button : $icon_name / $icon_text"
        sed \
            -e "s|icon_path|$icon_path|" \
            -e "s|icon_text|$icon_text|" \
            "$source" > "$target"
    done        
}

# invoke inkscape for svg -> png conversion (use default export)
convert_vector() {
    local base="$folder/source/mks_pic"
    local file name path source target
    for path in "$base"/*.svg ; do
        file=$(basename $path)
        name=${file%.*}
        source="$base/$name.svg"
        target="$base/$name.png"
        if [[ "$name" == "$template" ]] ; then
            continue # skip template
        fi
        echo "# convert vector: $name"
        inkscape \
            --without-gui \
            --export-dpi=96 \
            --export-png="$target" \
            --file="$source"
    done
                
}

# invoke gimp for png -> bin conversion (use plugin export)
convert_raster() {
    local base="$folder/source/mks_pic"
    local file name path source target
    for path in "$base"/*.png ; do
        file=$(basename $path)
        name=${file%.*}
        source="$base/$name.png"
        target="$base/bmp_$name.bin"
        if [[ "$name" == "$template" ]] ; then
            continue # skip template
        fi
        echo "# convert raster: $name"
gimp --no-interface --batch-interpreter=python-fu-eval --batch - <<EOF
import gimpfu # gimp api
def convert(source, target): # svg to bin
    image = pdb.gimp_file_load(source, source) # load svg
    drawable = pdb.gimp_image_get_active_drawable(image) # find canvas
    pdb.python_fu_export_C_code_bin(image,drawable,target,1) # save bin
convert('${source}', '${target}') # inject bash args
pdb.gimp_quit(1) # force quit
EOF
    done
}

# mks-tft sd-card
disk_mount() {
    echo "# mount ..."
    while ! mountpoint -q $point ; do
        sudo mount $disk $point -o uid=$USER,gid=$USER
        sleep 1
    done
    echo "# mount ok"
}

# mks-tft sd-card
disk_umount() {
    echo "# umount ..."
    while mountpoint -q $point ; do
        sudo umount $disk
        sleep 1
    done
    echo "# umount ok"
}

echo "# check folder"
readonly folder=$( cd $( dirname ${BASH_SOURCE[0]} ) && pwd )
if [[ "$folder" == "" ]] ; then
    echo "# invalid script folder"
    exit 1
fi
echo "# using folder: $folder"

echo "# locate disk"
readonly parse_text=$(sudo lsblk -n -l -o name,label | grep $label) || true
if [[ "$parse_text" == "" ]] ; then
    echo "# missing disk for label: $label"
    exit 1
fi
readonly parse_list=($parse_text)
readonly disk="/dev/${parse_list[0]}"

mkdir -p "$point"

echo "# found disk: $disk"
echo "# using point: $point"

disk_umount

echo "# erase archive"
rm -r -f "$folder/archive"/*

echo "# fetch mks-tft"
wget -q "$mks_url" -O "$folder/mks-tft.zip"

echo "# extract mks-tft"
unzip -q "$folder/mks-tft.zip" -d "$folder/archive/"

echo "# fetch glyph-icons"
wget -q "$glyph_url" -O "$folder/glyph-icons.zip"

echo "# extract glyph-icons"
unzip -q "$folder/glyph-icons.zip" -d "$folder/archive/"

echo "# erase target"
rm -r -f "$folder/target"/*

echo "# copy mks-tft"
cp -a -r -f "$folder/archive/$mks_profile"/. "$folder/target"/

echo "# copy config"
cp -a -r -f "$folder/source"/*.txt "$folder/target"/

echo "# make icons"
make_icons
convert_vector
convert_raster

echo "# edit names"
mv -f "$folder/source/mks_pic"/bmp_iconlogo.bin "$folder/source/mks_pic"/bmp_iconlogo.lg

echo "# copy icons"
mkdir -p "$folder/target/mks_pic"
cp -a -r -f "$folder/source/mks_pic"/*.{bin,lg} "$folder/target/mks_pic"/

disk_mount

echo "# erase disk"
rm -r -f "$point"/*

echo "# copy target"
cp -r -f "$folder/target"/. "$point"/

disk_umount

rm -r -f "$point"
