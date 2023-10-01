#!/bin/bash
# conkynetwork.sh
# by Crinos512
# Usage:
#  ${execp ~/.conky/conkyparts/conkynetwork.sh}
#
echo "Network: (Internal: \${color2}\${addrs wlan0}\${color}, External: \${color2}\${exec wget -q -O - checkip.dyndns.org | sed -e 's/[^[:digit:]|.]//g'}\${color} ) \${color1}\${hr 1}\${color}"
echo "\${goto 20}\${downspeedgraph wlan0 25,175 000000 ff0000} \${alignr}\${upspeedgraph wlan0 25,175 000000 00ff00}    "
echo "\${voffset -32}     down \${color2}\${downspeedf wlan0} k/s \${color}\${goto 209}up \${color3}\${upspeedf wlan0} k/s\${color}"
echo "     total down: \${color2}\${totaldown wlan0}\${color}\${goto 209}total up: \${color3}\${totalup wlan0}\${color}"
echo ""

exit 0
