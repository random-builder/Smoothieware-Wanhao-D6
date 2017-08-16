#!/bin/bash

# mks-base firmware generator

set -e

# sd-card partition label
readonly label="MKS-BASE"

# sd-card mount folder
readonly point="/tmp/$label"

# firmware source
readonly firmware_url="https://github.com/Smoothieware/Smoothieware/raw/edge/FirmwareBin/firmware-latest.bin"

# firmware target file
readonly firmware_file="firmware.bin"

# mks-base sd-card
disk_mount() {
    echo "# mount ..."
    while ! mountpoint -q $point ; do
        sudo mount $disk $point -o uid=$USER,gid=$USER
        sleep 1
    done
    echo "# mount ok"
}

# mks-base sd-card
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
readonly parse_text=$(lsblk -n -l -o name,label | grep $label) || true
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

echo "# erase target"
mkdir -p "$folder/target"
rm -r -f "$folder/target"/*

echo "# fetch firmware"
wget -q "$firmware_url" -O "$folder/target/$firmware_file"

echo "# copy config"
cp -a -r -f "$folder/source"/*.txt "$folder/target"/

disk_mount

echo "# erase disk"
rm -r -f "$point"/*

echo "# copy target"
cp -a -r -f "$folder/target"/. "$point"/

disk_umount

rm -r -f "$point"

