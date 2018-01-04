#!/bin/bash

set -euo pipefail

confirm() {
    local answer
    read -r -p "$1 [y/n]? " answer
    if [ "$answer" != "y" ]; then
        return 1
    fi
}

fail() {
    echo "$*"
    exit 1
}

check_is_block_device() {
    local device="$1"
    if [ ! -b "$device" ] ; then
        fail "'${device}' either doesn't exist or isn't a block device"
    fi    
}

check_device_is_not_mounted() {
    local device="$1"
    if [ "$(mount | grep -c ${device})" -ne 0 ] ; then
        fail "Device '${device}' looks mounted to me"
    fi
}

check_running_as_root() {
    if [ "$(whoami)" != "root" ]; then
        fail This must be run as root
    fi
}


if [ $# -ne 1 ]; then
    echo You must specify the block device to use
    exit 1
fi

DEVICE="$1"

# https://wiki.archlinux.org/index.php/Installation_guide

#check_running_as_root
#check_is_block_device "$DEVICE"
check_device_is_not_mounted "$DEVICE"
#fdisk -l "$DEVICE"
confirm "This will remove all the shit on ${DEVICE}, are you sure?" || fail "Aborted"

newdisk="label: dos
device: ${DEVICE}
unit: sectors

${DEVICE}1 : start=        2048, size=     2097152, type=83
${DEVICE}2 : start=     2099200, type=83"

echo "$newdisk" > sfdisk "$DEVICE" 
