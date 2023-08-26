#!/bin/bash
#set -e
#parted /dev/nvme0n1 <<EOF
#mklabel gpt
#mkpart primary fat32 1MiB 501MiB
#set 1 esp on
#mkpart primary btrfs 501MiB 1501MiB
#mkpart primary btrfs 1501MiB 51501MiB
#mkpart primary btrfs 51501MiB 100%
#quit
#EOF

#mkfs.fat -F32 /dev/nvme0n1p1
#mkfs.btrfs /dev/nvme0n1p2
#mkfs.btrfs /dev/nvme0n1p3
#mkfs.btrfs /dev/nvme0n1p4

#mount /dev/nvme0n1p3 /mnt
#mkdir /mnt/boot
#mkdir /mnt/home
#mount /dev/nvme0n1p2 /mnt/boot
#mount /dev/nvme0n1p4 /mnt/home

#pacman -Syy
#pacman -S reflector
#cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
#reflector -c "US" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist
#pacstrap /mnt base linux linux-firmware vim nano
#genfstab -U /mnt >> /mnt/etc/fstab
#arch-chroot /mnt
#ln -sf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime
#hwclock --systohc
#locale-gen
#echo "LANG=en_US.UTF-8" > /etc/locale.conf
#export LANG=en_GB.UTF-8
#echo myarch > /etc/hostname
#echo '127.0.0.1	localhost' > /etc/hosts
#echo '::1		localhost' >> /etc/hosts
#echo '127.0.1.1	myarch' >> /etc/hosts
#passwd
#pacman -S grub
#grub-install --target=i386-pc /dev/nvme0n1p2
#grub-mkconfig -o /boot/grub/grub.cfg
#umount -R /mnt
#reboot

pacman -S pamac
pamac enable AUR
pacman -Syy

for var in $(cat arc_pkg_list);
do
    pacman -S $var
done