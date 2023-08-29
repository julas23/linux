#!/bin/bash
echo "" >> /var/log/backup
echo "Starting Backup Process" >> /var/log/backup
rsync_options="-avu --delete"

source_directory=""
destination_directory=""

# Function to display usage information
display_usage() {
    echo "Usage: $0 [-s|--source SOURCE_DIR] [-d|--destination DEST_DIR]"
    exit 1
}

# Function to check if a directory is mounted
is_mounted() {
    mountpoint "$1"
}

# Function to attempt mounting a directory
attempt_mount() {
    if ! is_mounted "$1"; then
        echo "Mounting '$1'..."
        if ! mount "$1"; then
            echo "Failed to mount '$1'. Aborting."
            sudo echo $(date +'%A %d %B %Y %H:%M') 'Failed during the mount' >> /var/log/backup

            exit 1
        fi
    fi
}

# Process command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -s|--source)
        source_directory="$2"
        shift 2
        ;;
        -d|--destination)
        destination_directory="$2"
        shift 2
        ;;
        *)
        echo "Unknown option: $1"
        display_usage
        sudo echo $(date +'%A %d %B %Y %H:%M') 'Unknown option' >> /var/log/backup
        ;;
    esac
done

# Check if required parameters are provided
if [ -z "$source_directory" ] || [ -z "$destination_directory" ]; then
    echo "Missing required parameters."
    echo $(date +'%A %d %B %Y %H:%M') 'Missing parameters' >> /var/log/backup
    display_usage
fi

# Check if provided directories exist
if [ ! -d "$source_directory" ]; then
    echo "Source directory '$source_directory' does not exist."
    echo $(date +'%A %d %B %Y %H:%M') 'Source Directory does not exist' >> /var/log/backup
    exit 1
fi

if [ ! -d "$destination_directory" ]; then
    echo "Destination directory '$destination_directory' does not exist."
    echo $(date +'%A %d %B %Y %H:%M') 'Destination Directory does not exist' >> /var/log/backup
    exit 1
fi

# Attempt to mount destination directory if it's not mounted
attempt_mount "$destination_directory"

# Compare files between source and destination directories
diff_output=$(rsync -rcv --delete "$source_directory/" "$destination_directory/")

if [ -n "$diff_output" ]; then
    echo "Differences found. Synchronizing..."
    rsync $rsync_options "$source_directory/" "$destination_directory/" >> /var/log/backup
    echo "Synchronization complete."
else
    echo "No differences found."
fi

echo $(date +'%A %d %B %Y %H:%M') 'Backup finished successfuly!' >> /var/log/backup
echo "" >> /var/log/backup
shutdown -h now