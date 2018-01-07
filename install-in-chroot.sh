#!/bin/bash

set -euo pipefail

ln -sf /usr/share/zoneinfo/Australia/Melbourne /etc/localtime
systemctl enable systemd-networkd.service
systemctl enable sshd.service
systemctl enable smbd.service
systemctl enable nmbd.service

echo "Password for root"
passwd
groupadd -r sudo
useradd -m -G docker,sudo shorty
echo "Password for shorty"
passwd shorty
echo "Password for shorty again"
smbpasswd -L -a shorty
mkdir /home/shorty/.ssh
curl https://github.com/porty.keys > /home/shorty/.ssh/authorized_keys
chown -R shorty:shorty /home/shorty/.ssh/
