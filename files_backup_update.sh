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
cp /etc/fstab $TARGET/fstab
cp /etc/passwd $TARGET/passwd
crontab -l > $TARGET/crontab.bak
cp ~/.xinitrc $TARGET/.xinitrc

echo 'MariaDB Dump backup'
mariadb-dump -x -A -u juliano -pjas2305X -h localhost --all-databases > $TARGET/conky.sql

echo 'ZSH Theme'
cp -r /usr/share/zsh-theme-powerlevel10k $TARGET
cp -r /usr/share/zsh $TARGET

echo 'Removing 6 hour old backups. This list will be deleted.'
find $TARGET -type d -cmin +360 -print
find $TARGET -type d -cmin +360 -exec rm -r {} \;

echo 'Backup Garuda Pacman conf.'
sudo cp /etc/pacman.conf $TARGET
sudo cp -r /etc/pacman.d $TARGET
sudo chown juliano:juliano $TARGET -R
sudo chmod +r $TARGET -R
