#!/bin/bash

j=1
until $_DONE
do
	if [ $(dbus-send --print-reply --type=method_call --dest=org.freedesktop.compiz /org/freedesktop/compiz/dbus/screen0 org.freedesktop.compiz.list 2>/dev/null | wc -l) -ne 0 ]
		then _DONE=true
	elif [ $j -gt 6 ]
		then _DONE=true
	else
		_DONE=false
		sleep 5
		let $[++j]
	fi
done

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd ${DIR} && conky -c ${DIR}"/one4all.rc"

exit 1

