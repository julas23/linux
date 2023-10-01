#!/bin/bash
# conkytemplate.sh
# by Crinos512
# Usage:
#  ${execpi 3600 ~/.conky/conkyparts/conkytemplate.sh}
#
BGColor="Black"
Columns=11
Rows=26
Layers=8

### DO NOT EDIT BELOW THIS LINE
for ((x=1; x <= $Rows; x++))
do
  case "$x" in
    1)
      Prefix="\${font conkybackgroundfi:size=13.5}\${color $BGColor}"
      BeginPart="\${goto 0}E"
      MidPart=""
      EndPart="F"
      i=$((Columns-2))
      ;;
    $Rows)
      Prefix=""
      BeginPart="\${goto 0}G"
      MidPart=""
      EndPart="C"
      i=$((Columns-2))
      ;;
    *)
      Prefix=""
      BeginPart="\${goto 0}"
      MidPart=""
      EndPart=""
      i=$Columns
      ;;
  esac
  while [ $i -gt 0 ]; do
    MidPart="${MidPart}D"
    let i=i-1
  done
  Part="${BeginPart}${MidPart}${EndPart}"
  g=0
  Line=""
  while [ $g -lt $Layers ]; do
    Line="${Line}${Part}"
    let g=g+1
  done
  echo "\${voffset -2}$Prefix$Line"
done
echo "\$font\$color\${voffset -$( echo "scale=9; $Rows*35" | bc )}"

exit 0