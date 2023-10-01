#!/bin/bash
# conkycalender.sh
# by Crinos512
# Usage:
#  ${execp ~/.conky/conkyparts/conkycalender.sh}
#
DJS=`date +%_d`

echo "\${exec date +'%B %Y' | tr '[:lower:]' '[:upper:]'} \${color1}\${hr 1}\${color}"
for i in {1..7}
do
  Text=`cal | sed '1d' | sed '/./!d' | sed 's/$/                     /' | sed -n '/^.\{21\}/p' | head -n $i | tail -n 1 | sed -n '/^.\{21\}/p' | sed 's/^/${alignc} /' | sed /" $DJS "/s/" $DJS "/" "'${color2}'"$DJS"'${color}'" "/`
  echo "\${font Liberation Mono:size=9}\${goto 125}$Text\${font}"
done

exit 0
