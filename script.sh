#!/bin/bash

USERNAME=`sudo cat /etc/passwd |grep '1000:1000' |cut -d: -f 1`
echo "$USERNAME	ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/1000-$USERNAME
usermod -G root $USERNAME
usermod -G $USERNAME root
cp /FS/DATA/$USERNAME/.git/linux/myls /usr/bin/myls
chmod +x /usr/bin/myls
