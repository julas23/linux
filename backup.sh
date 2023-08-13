#!/bin/bash

rsync_options="-avu --delete"

source_directory=""
destination_directory=""

# Function to display usage information
display_usage() {
    echo "Usage: $0 [-s|--source SOURCE_DIR] [-d|--destination DEST_DIR]"
    exit 1
}

# Function to display progress status
display_status() {
    total_size=$(du -sh "$source_directory" | cut -f1)
    sync_size=$(du -sh "$destination_directory" | cut -f1)
    pending_size=$(du -shc --exclude="$destination_directory" "$source_directory" | grep "total$" | cut -f1)
    percentage=$(echo "scale=2; ($sync_size / $total_size) * 100" | bc)
    
    rsync_info=$(rsync --info=progress2 --dry-run "$source_directory/" "$destination_directory/" | tail -n 1)
    current_speed=$(echo "$rsync_info" | awk '{print $3}')
    current_time=$(echo "$rsync_info" | awk '{print $4}')
    time_left=$(echo "$rsync_info" | awk '{print $5}')
    
    echo "Total Size: $total_size   Synced: $sync_size  Pending: $pending_size  Progress: $percentage%"
    echo "Current Speed: $current_speed/s  Current Time: $current_time  Time Left: $time_left"
}

# Process command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -s|--source)
        source_directory="$2"
        shift
        shift
        ;;
        -d|--destination)
        destination_directory="$2"
        shift
        shift
        ;;
        *)
        echo "Unknown option: $1"
        display_usage
        ;;
    esac
done

# Check if required parameters are provided
if [ -z "$source_directory" ] || [ -z "$destination_directory" ]; then
    echo "Missing required parameters."
    display_usage
fi

# Check if provided directories exist
if [ ! -d "$source_directory" ]; then
    echo "Source directory '$source_directory' does not exist."
    exit 1
fi

if [ ! -d "$destination_directory" ]; then
    echo "Destination directory '$destination_directory' does not exist."
    exit 1
fi

# Compare files between source and destination directories
diff_output=$(diff -qr "$source_directory" "$destination_directory")

if [ -n "$diff_output" ]; then
    echo "Differences found. Updating rsync..."
    rsync $rsync_options --info=progress2 "$source_directory/" "$destination_directory/" | while read line; do
        display_status
    done
    echo "rsync update complete."
else
    echo "No differences found."
fi
