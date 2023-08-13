#!/bin/bash

#!/bin/bash

local_nvme="/home"
case_nvme="/BKP"
user_directory="juliano"
rsync_options="-avu --delete"

# Compare files between local NVMe and NVMe in the case
diff_output=$(diff -qr "$local_nvme/$user_directory" "$case_nvme/$user_directory")

if [ -n "$diff_output" ]; then
    echo "Differences found. Updating rsync..."
    rsync $rsync_options "$local_nvme/$user_directory/" "$case_nvme/$user_directory/"
    echo "rsync update complete."
else
    echo "No differences found."
fi

