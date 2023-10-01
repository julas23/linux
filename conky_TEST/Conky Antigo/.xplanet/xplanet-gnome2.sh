#!/bin/bash

# Add this script to System->Preferences->Sessions->Startup Programs
# how long to sleep between drawings
sleep=2m

month=`/bin/date +%m`
# create symbolic link for day image
/bin/ln -sf ${HOME}/.xplanet/world/${month}.jpg ${HOME}/.xplanet/earth.jpg

# screen size
geometry=1920x1080

# where to keep the desktop image
prefix=${HOME}/.gnome2_private/
logFile=${prefix}/xplanet.log

# the name of the desktop image
base=xplanet
extension=png

# check to see if we're still logged in
loggedIn=$(ps U $USER | grep gnome-session|grep -v grep)
if [ -z "$loggedIn" ]; then
    echo "exiting at $(date)" >> $logFile
    exit
fi

# Alternate between two filenames
append=2
first=${base}.${extension}
second=${base}${append}.${extension}

currentBackground=$(basename $(gconftool -g /desktop/gnome/background/picture_filename))

# Set the name of the output file to be different than the current background
if [ $currentBackground != $first ]; then
  outputFile=${prefix}/${first}
 else
  outputFile=${prefix}/${second}
fi

# Remove the current background once the new background has been set
rmFile=${prefix}/${currentBackground}

# The xplanet command
xplanet -num_times 1 -output $outputFile -geometry $geometry -config ${HOME}/.xplanet/config \
        -longitude 0 -latitude 0 -body earth \
        -projection rectangular -transparency >> $logFile
 
# update Gnome backgound
gconftool -t str -s /desktop/gnome/background/picture_filename $outputFile

# Now get rid of the previous background
if [ -e $rmFile ]; then 
    sleep 1
    /bin/rm $rmFile
fi

sleep ${sleep}

# Run this script again
exec $0
