#!/bin/bash
/home/juliano/.xplanet/xplanet-download_clouds.py /home/juliano/.xplanet/clouds_4096.jpg
# /usr/bin/convert -crop geometry 4096×1700+0+174 /home/juliano/.xplanet/clouds_4096.jpg /home/juliano/.xplanet/clouds_custom.jpg
/usr/bin/convert -resize 1920 /home/juliano/.xplanet/clouds_4096.jpg /home/juliano/.xplanet/clouds.jpg
rm -f /home/juliano/.xplanet/clouds_4096.jpg
