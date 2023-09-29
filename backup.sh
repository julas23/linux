#!/bin/bash

echo "" >> /var/log/backup
echo "Starting Backup Process" >> /var/log/backup

source_directory="/FS/DATA"
destination_directory="/FS/BACK"

TARGET=$destination_directory/linux_backup/$(date +'%a%d%b%Hh')
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

echo 'Backup Pacman conf.'
sudo cp /etc/pacman.conf $TARGET
sudo cp -r /etc/pacman.d $TARGET
sudo cp -r /var/log/backup $TARGET
sudo chown juliano:juliano $TARGET -R
sudo chmod +r $TARGET -R

diff_output=$(rsync -rcv --delete "$source_directory/" "$destination_directory/")

if [ -n "$diff_output" ]; then
    echo "Differences found. Synchronizing..."
    rsync -avu --delete "$source_directory/" "$destination_directory/" >> /var/log/backup
    echo "Synchronization complete."
else
    echo "No differences found."
fi

echo $(date +'%A %d %B %Y %H:%M') 'Backup finished successfuly!' >> /var/log/backup
echo "" >> /var/log/backup