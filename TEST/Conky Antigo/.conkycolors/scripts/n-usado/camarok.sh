#!/bin/bash
# amaroK info display script by julas <julianoas@gmail.com>
# requirements: amaroK (!)

#ttime= expr `dcop amarok player trackTotalTime` / 60
# ctime=$ (( expr `dcop amarok player trackCurrentTime` / 60 ))
# rest=$ (( expr `dcop amarok player trackTotalTime` - `dcop amarok player trackCurrentTime` ))

 case "$1" in

# Now Playing Info
artist) dcop amarok player artist ;;
title)  dcop amarok player title ;;
album)  dcop amarok player album ;;
tempo) dcop amarok player trackCurrentTime ;;
total) dcop amarok player trackTotalTime ;;
# teste) echo $ttime ;;

esac

