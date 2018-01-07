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

check_running_as_root() {
    if [ "$(whoami)" != "root" ]; then
        fail This must be run as root
    fi
}

cproot() {
    cp -p "$1" "$2"
    chown root:root "$2"
}

check_running_as_root

if [ $# -ne 1 ]; then
    echo You must specify the directory to install stuff to
    exit 1
fi

ROOT="$1"

set -x

pacstrap -d "$ROOT" base sudo samba screen btrfs-progs htop docker zstd lm_sensors lsof openssh pv rsync unrar grub
cproot config/fstab "$ROOT"/etc/fstab
cproot config/smb.conf "$ROOT"/etc/samba/
cproot config/sudo-group.conf "$ROOT"/etc/sudoers.d/
cproot config/mirrorlist "$ROOT"/etc/
cproot config/screenrc "$ROOT"/etc/
cproot config/locale.gen "$ROOT"/etc/
cproot config/locale.conf "$ROOT"/etc/
cproot config/dhcp-wired.network "$ROOT"/etc/systemd/network/

echo nas1 > "$ROOT"/etc/hostname
echo "127.0.1.1       nas1" >> "$ROOT"/etc/hosts

cproot install-in-chroot.sh "$ROOT"/
arch-chroot "$ROOT" /install-in-chroot.sh
rm "$ROOT"/install-in-chroot.sh

set +x

echo "OK, to copy to device use cp -p -R $ROOT path/to/device"
