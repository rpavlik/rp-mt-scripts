#!/bin/bash

THISSCRIPT="install_flashplayer_standalone.sh"
source ../z_config.inc

# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Downloads and installs the standalone flash player.

cd $MTROOT/tmp
echo "Getting latest download URL and downloading..."
# Get URL from Adobe's site of the first-listed "linux dev" package
DOWNURL=$(wget -q http://www.adobe.com/support/flashplayer/downloads.html -O - |egrep -o "http\://[a-zA-Z0-9\.\_/]*linux_dev\.tar\.gz"|head -n 1)
DOWNFILE=$(echo $DOWNURL | egrep -o "[a-zA-Z0-9\.\_]*$")
TARDIR=$(echo $DOWNFILE | egrep -o "^[a-zA-Z0-9\_]*")
wget $DOWNURL

echo "Downloaded $DOWNURL to $MTROOT/tmp" >> $LOGFILE

echo "Unzipping..."
cd $MTROOT/other3rdparty
tar xzf $MTROOT/tmp/$DOWNFILE
mv $TARDIR flashplayer_standalone
cd flashplayer_standalone/standalone/release
tar xzf flashplayer.tar.gz

log_append("Unzipped file to directory $MTROOT/other3rdparty/flashplayer_standalone")
#echo "Unzipped file to directory $MTROOT/other3rdparty/flashplayer_standalone" >> $LOGFILE
echo "Unzipped internal package in $MTROOT/other3rdparty/flashplayer_standalone/standalone/release/" >> $LOGFILE
echo "Script terminated successfully at " >> $LOGFILE
echo "Done!  You can now use the run_flashplayer_standalone.sh script."

echo
read -p "Press enter or wait 10 seconds to continue..." -t 10
echo

