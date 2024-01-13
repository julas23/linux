#!/bin/bash

echo "" >> /var/log/backup
echo "Starting Backup Process" >> /var/log/backup

PASSWORD='jas2305X'
SOURCE='/FS/DATA'
DESTIN='/FS/BACK/'
TSTAMP=$(date +'%a%d%b%Hh')
TARGET=$SOURCE'/linux_backup/'$TSTAMP

sudo chown juliano:juliano /FS/ -R
sudo chmod 755 /FS/ -R

is_mounted() {
    mountpoint -q $DESTIN
}

attempt_mount() {
    if ! is_mounted "$DESTIN"; then
        echo "Mounting '$DESTIN'..."
        if ! mount "$DESTIN"; then
            echo "Failed to mount '$DESTIN'. Aborting."
            exit 1
        fi
    fi
}

test_check(){
    echo 'PASSWORD' $PASSWORD
    echo 'SOURCE' $SOURCE
    echo 'DESTI' $DESTIN
    echo 'TSTAMP' $TSTAMP
    echo 'TARGET' $TARGET
    echo 'mkdir' $TARGET
}

linuxfiles(){
    is_mounted
    mkdir $TARGET
    echo $TARGET 'created successfully'

    echo 'Backup of Crontab'
    crontab -l > $TARGET/crontab.bak

    echo 'Backup of Oh_My_Zsh'
    tar czf $TARGET/oh-my-zsh.tar.gz $SOURCE/juliano/.oh-my-zsh

    echo 'Backup of Git'
    tar czf $TARGET/Git.tar.gz $SOURCE/juliano/Git

    echo 'Backing Up Linux files'
    cp ~/.zshrc $TARGET/
    cp ~/.bashrc $TARGET/
    cp ~/.aliasrc $TARGET/
    cp /etc/default/grub $TARGET/grub
    cp /etc/mkinitcpio.conf $TARGET/mkinitcpio.conf
    cp /etc/fstab $TARGET/fstab
    cp /etc/juliano_rc.local $TARGET/juliano_rc.local
    cp /etc/systemd/system/juliano.service $TARGET/juliano.service
    cp /etc/passwd $TARGET/passwd
    crontab -l > $TARGET/crontab.bak
    cp ~/.xinitrc $TARGET/.xinitrc

    echo 'MariaDB Dump backup'
    sudo mariadb-dump -x -A -u juliano -p$PASSWORD -h localhost --all-databases > $TARGET/db_$TSTAMP.sql

    echo 'Removing 7 days old backups. This list will be deleted.'
    find $SOURCE/linux_backup/ -type d -mtime +7 -print
    find $SOURCE/linux_backup/ -type d -mtime +7 -exec rm -r {} \;
    find $SOURCE/linux_backup/ -type d -mtime +7 -delete;

    sudo chown juliano:juliano $TARGET -R
    sudo chmod +r $TARGET -R
}

filesystem(){
    is_mounted
    if [ ! -d "$SOURCE" ]; then
        echo "Source directory '$SOURCE' does not exist."
        exit 1
    fi

    if [ ! -d "$DESTIN" ]; then
        echo "Destination directory '$DESTIN' does not exist."
        exit 1
    fi

    attempt_mount "$DESTIN"

    diff_output=$(rsync -rcv --delete "$SOURCE/" "$DESTIN/")

    if [ -n "$diff_output" ]; then
        echo "Differences found. Synchronizing..."
        rsync -avu --delete "$SOURCE/" "$DESTIN/" >> /var/log/backup
        echo "Synchronization complete."
    else
        echo "No differences found."
    fi
}

how_to_use(){
    echo '-a run full backup'
    echo '-l run linux files backup only'
    echo '-f run filesystem backup only'
}

if   [ "$1" == "-l" ]; then linuxfiles
elif [ "$1" == "-c" ]; then test_check
elif [ "$1" == "-f" ]; then filesystem
elif [ "$1" == "-a" ]; then
    linuxfiles
    filesystem
    clear
    echo 'System is going to halt in 30 seconds'
    sleep 30
    sudo shutdown -h now 
elif [ -z "$1" ]; then
    how_to_use
else
    echo "Invalid Argument. Use 'linux_files', 'filesystem' or keep empty to run both."
fi
NOW=$(date +'%A %d %B %Y %H:%M')
echo $NOW 'Backup finished successfuly!' >> /var/log/backup
echo "" >> /var/log/backup