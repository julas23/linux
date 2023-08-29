#!/bin/bash

clear

TARGET=/FS/DATA/linux_backup/$(date +'%a%d%b%Hh')
mkdir $TARGET
echo $TARGET 'created successfully'

echo 'Backup of Crontab'
crontab -l $TARGET/crontab.bak

echo 'Updating data.'
/home/juliano/.git/conky/data update

echo 'Backing Up Linux files'
cp /etc/default/grub $TARGET/grub
cp /etc/X11/xorg.conf $TARGET/xorg.conf
crontab -l > $TARGET/crontab.bak

echo 'MariaDB Dump backup'
mariadb-dump -x -A -u juliano -pjas2305X -h localhost --all-databases > $TARGET/conky.sql

echo 'Copy Wallpaper file'
sudo cp /home/juliano/.git/conky/worldmapwp/images/*.jpg /usr/share/wallpapers/bg.jpg
sudo chmod +r /usr/share/wallpapers/bg.jpg

echo 'Removing 6 hour old backups. This list will be deleted.'
find $TARGET -type d -cmin +360 -print
find $TARGET -type d -cmin +360 -exec rm -r {} \;

echo 'Backup Garuda Pacman conf.'
sudo cp /etc/pacman.conf $TARGET
sudo cp -r /etc/pacman.d $TARGET
sudo chown juliano:juliano $TARGET -R
sudo chmod +r $TARGET -R
