#!/bin/sh
# conkymemory.sh
# by Crinos512
# Usage:
#  ${execp ~/.conky/conkyparts/conkymemory.sh}
#
echo "\${goto 19}\${memgraph 25,361 000000 4682B4}"
echo "\${voffset -60}"
echo "\${font Liberation Mono:size=9}  RAM Usage: \${color2}\$memperc%\${color}\${goto 225}\${color2}\$mem\${color} of \${color2}\$memmax\${color}"
echo "    Processes Loaded: \${color2}\$processes\${color}\${goto 225}Cached: \${color2}\$cached\${color}"
echo "    Processes Running: \${color2}\$running_processes\${color}\${goto 225}Buffers: \${color2}\$buffers\${color}\${font}"
echo "\${color3}\${goto 20}\${membar 6,359}\${color}"
echo "\${font Liberation Mono:size=9}  Swap Usage: \${color2}\$swapperc%\${color}\${goto 225}\${color2}\$swap\${color} of \${color2}\$swapmax\${color}\${font}"
echo "\${color3}\${goto 20}\${swapbar 6,359}\${color}"


exit 0