#!/bin/bash
# conkyheader.sh
# by Crinos512
# Usage:
#  ${execp ~/.conky/conkyparts/conkyheader.sh}
#
echo "\${goto 20}\${font tattoo:size=50}\${color1}c\${goto 323}c\${font}\${color}"
echo "\${voffset -50}\${font Algerian:Bold:size=16}\${alignc}\${color3}\$nodename\${font}"
echo "\${font Liberation Sans:Bold:size=10}\${alignc}~ \$kernel ~"
echo "\${alignc}~ K\${exec lsb_release -i | cut -f 2| tr "[:upper:]" "[:lower:]"} \${exec lsb_release -c | cut -f 2} ( \${exec lsb_release -r | cut -f 2} ) ~ \${exec kde4-config --version | grep 'KDE' | head --bytes=11} ~\${color}\${font}"

exit 0