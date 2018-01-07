# Arch Installer

Installs Arch for the nas. Replace `/dev/sdf` for whatever it really should be.

## Pre Stuff

Partition/format the disk

```
fdisk /dev/sdf

mkfs.ext4 -L booty /dev/sdf1
mkfs.ext4 -L rooty /dev/sdf2
```

`sfdisk` output looks like:

```
label: dos
label-id: 0x24aa2ec2
device: /dev/sdf
unit: sectors

/dev/sdf1 : start=        2048, size=     2097152, type=83
/dev/sdf2 : start=     2099200, size=   118834688, type=83
```

## During

It will ask for root/user passwords.

If you're not running this in the final location (i.e. in a temp directory) run `sudo cp -p -R the/temp/dir/* the/root/dir/with/boot/mounted/` to copy files with permissions.

## After

Booting in to the arch installer, run:

```
mount -o noatime /dev/sdf2 /mnt
mount -o noatime /dev/sdf1 /mnt/boot

timedatectl set-ntp true

arch-chroot /mnt

# within the arch-chroot
hwclock --systohc
mkinitcpio -p linux
grub-install  --target=i386-pc /dev/sdf
grub-mkconfig -o /boot/grub/grub.cfg
```

Then unmount and reboot
