#!/bin/bash

echo "" >> /var/log/backup
echo "Starting Backup Process" >> /var/log/backup

PASSWORD=$(cat data.ini |grep PASSWORD |cut -d= -f2)
SOURCE_DIRECTORY=$(cat data.ini |grep SOURCE_DIRECTORY |cut -d= -f2)
DESTINATION_DIRECTORY=$(cat data.ini |grep DESTINATION_DIRECTORY |cut -d= -f2)
TARGET=$SOURCE_DIRECTORY"/linux_backup/"$(date +'%a%d%b%Hh')


is_mounted() {
    mountpoint -q $DESTINATION_DIRECTORY
}
attempt_mount() {
    if ! is_mounted "$DESTINATION_DIRECTORY"; then
        echo "Mounting '$DESTINATION_DIRECTORY'..."
        if ! mount "$DESTINATION_DIRECTORY"; then
            echo "Failed to mount '$DESTINATION_DIRECTORY'. Aborting."
            exit 1
        fi
    fi
}

linuxfiles(){
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
    mariadb-dump -x -A -u juliano -p$PASSWORD -h localhost --all-databases > $TARGET/conky.sql

    echo 'ZSH Theme'
    cp -r /usr/share/zsh-theme-powerlevel10k $TARGET
    cp -r /usr/share/zsh $TARGET

    #echo 'Removing 6 hour old backups. This list will be deleted.'
    #find $TARGET -type d -cmin +360 -print
    #find $TARGET -type d -cmin +360 -exec rm -r {} \;

    echo 'Backup Pacman conf.'
    sudo cp /etc/pacman.conf $TARGET
    sudo cp -r /etc/pacman.d $TARGET
    sudo cp -r /var/log/backup $TARGET
    sudo chown juliano:juliano $TARGET -R
    sudo chmod +r $TARGET -R
}

filesystem(){
    if [ ! -d "$SOURCE_DIRECTORY" ]; then
        echo "Source directory '$SOURCE_DIRECTORY' does not exist."
        exit 1
    fi

    if [ ! -d "$DESTINATION_DIRECTORY" ]; then
        echo "Destination directory '$DESTINATION_DIRECTORY' does not exist."
        exit 1
    fi

    attempt_mount "$DESTINATION_DIRECTORY"

    diff_output=$(rsync -rcv --delete "$SOURCE_DIRECTORY/" "$DESTINATION_DIRECTORY/")

    if [ -n "$diff_output" ]; then
        echo "Differences found. Synchronizing..."
        rsync -avu --delete "$SOURCE_DIRECTORY/" "$DESTINATION_DIRECTORY/" >> /var/log/backup
        echo "Synchronization complete."
    else
        echo "No differences found."
    fi
}

if   [ "$1" == "linuxfiles" ]; then linuxfiles
elif [ "$1" == "filesystem" ]; then filesystem
elif [ -z "$1" ]; then
    linuxfiles
    filesystem
else
    echo "Invalid Argument. Use 'linux_files', 'filesystem' or keep empty to run both."
fi

echo $(date +'%A %d %B %Y %H:%M') 'Backup finished successfuly!' >> /var/log/backup
echo "" >> /var/log/backup
