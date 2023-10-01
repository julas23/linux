#!/usr/bin/python
#
# download_clouds.py ver. 1.1
#
# Download coulds map for xplanet from a random mirror, optionally
# save the one to archive directory.
#
# Usage:
#   python download_clouds.py - to save the output as clouds_2048.jpg
#   python download_coulds.py output.jpg - to save the output as output.jpg
#
# (C) 2004 Michal Pasternak <michal@pasternak.w.lub.pl>
#
# This file is in public domain.

# user-tunable parameters:

# how often to download the image?
maxDownloadFrequencyHours = 3

# how many times to retry if download fails (each time tries using a
# different mirror)
maxRetries = 3

# default filename of the output file (in current directory). You can
# specify it on the command line
#defaultOutputFile = "clouds_2048.jpg"
defaultOutputFile = "clouds_4096.jpg"

# archive dir - where to save old files?
archiveDir = None # "/usr/public/cloudsArchive"

# The list of mirrors. Add new ones here.
#mirrors = [    "ftp://mirror.pacific.net.au/pub2/xplanet/clouds_2048.jpg",
#               "http://www.ruwenzori.net/earth/clouds_2048.jpg",
#               "http://xplanet.arculeo.com/clouds_2048.jpg",
#               "http://xplanet.dyndns.org/clouds/clouds_2048.jpg",
#               "http://userpage.fu-berlin.de/~jml/clouds_2048.jpg",
#               "http://rcswww.urz.tu-dresden.de/~es179238/clouds_2048.jpg",
#               "http://home.megapass.co.kr/~ysy00/cloud_data/clouds_2048.jpg",
#               "http://home.megapass.co.kr/~holywatr/cloud_data/clouds_2048.jpg",
#               "http://user.chol.com/~winxplanet/cloud_data/clouds_2048.jpg",
#               "http://home.megapass.co.kr/~gitto88/cloud_data/clouds_2048.jpg",
#               "http://www.wizabit.eclipse.co.uk/xplanet/files/mirror/clouds_2048.jpg",
#               "http://www.wizabit.eclipse.co.uk/xplanet/files/local/clouds_2048.jpg",
#               "ftp://ftp.iastate.edu/pub/xplanet/clouds_2048.jpg",
#               "http://xplanet.explore-the-world.net/clouds_2048.jpg" ]

mirrors = [    "http://home.megapass.co.kr/~holywatr/cloud_data/clouds_4096.jpg",
               "http://www.ruwenzori.net/earth/clouds_4096.jpg",
               "http://userpage.fu-berlin.de/~jml/clouds_4096.jpg",
               "http://user.chol.com/~winxplanet/cloud_data/clouds_4096.jpg",
               "http://home.megapass.co.kr/~gitto88/cloud_data/clouds_4096.jpg",
               "ftp://ftp.iastate.edu/pub/xplanet/clouds_4096.jpg",
               "http://xplanet.explore-the-world.net/clouds_4096.jpg" ]

# end of user-tunable parameters

import random, urllib, sys, stat, time, os

# set output file name

try:
    outputFile = sys.argv[1]
except:
    outputFile = defaultOutputFile
    pass

# check if the file exists and is old enough to overwrite

try:
    s = os.stat(outputFile)
    mtime = s[stat.ST_MTIME]
    fs = s[stat.ST_SIZE]
    found = True
except:
    mtime = 0
    fs = 0
    found = False
    pass

if time.time() - mtime < maxDownloadFrequencyHours * 3600 and fs > 400000:
    sys.stderr.write("File is already up to date!\n")
    sys.exit(0)
else:
    if found and archiveDir is not None:
	# archivize old file
	import shutil
	archName = os.path.join(archiveDir, time.strftime("%Y-%m-%d_%H-%I") + "_" + os.path.basename(outputFile))
	sys.stderr.write("Archivizing old file to %s...\n" % archName)
	shutil.move(outputFile, archName)
	pass
    pass

# ok, download:

for a in range(maxRetries):
    try:
        url = mirrors [ random.randint(0, len(mirrors)-1) ]
        sys.stderr.write("Using %s\nDownloading...\n" % url)
        urllib.urlretrieve(url, outputFile)
        break
    except:
        pass
    pass

