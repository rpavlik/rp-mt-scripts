#!/bin/bash

THISSCRIPT="install_flashplayer_standalone.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Downloads and installs the standalone flash player.

# include config, global functions, and start log.
# NOLOGGING="NOLOGGING"
source ../z_config.inc

pushd . > /dev/null
FOUNDFILE=$(ls -p $MTROOT/downloads/ 2>/dev/null | grep "flash\_player\_.*gz$")
if [ -f "$MTROOT/downloads/$FOUNDFILE" ]; then
	echo "Apparently found download in $MTROOT/downloads/$FOUNDFILE - skipping download"
	log_append "Found what looks like the download at $MTROOT/downloads/$FOUNDFILE, skipping download"
	DOWNFILE=$FOUNDFILE
else
	cd $MTROOT/downloads
	echo "Getting latest download URL and downloading..."

	# Get URL from Adobe's site of the first-listed "linux dev" package
	# URL of download page: http://www.adobe.com/support/flashplayer/downloads.html
	# I found the download URL to be http://download.macromedia.com/pub/flashplayer/updaters/10/flash_player_10_linux_dev.tar.gz
	# but we'll let grep figure it out.

	DOWNURL=$(wget -q http://www.adobe.com/support/flashplayer/downloads.html -O - |egrep -o "http\://[a-zA-Z0-9\.\_/]*linux_dev\.tar\.gz"|head -n 1)
	DOWNFILE=$MTROOT/downloads/$(echo $DOWNURL | egrep -o "[a-zA-Z0-9\.\_]*$")
	wget $DOWNURL
	log_append_dated "Downloaded $DOWNURL to $MTROOT/downloads"
fi

echo "Unzipping..."
TARDIR=$(echo $DOWNFILE | egrep -o "^[a-zA-Z0-9\_]*")
cd $MTROOT/othersoftware
tar xzf $MTROOT/downloads/$DOWNFILE
mv $TARDIR flashplayer_standalone
log_append "Unzipped file to directory $MTROOT/othersoftware/flashplayer_standalone"

cd $MTROOT/othersoftware/flashplayer_standalone/standalone/release
tar xzf flashplayer.tar.gz
log_append "Unzipped internal package in $MTROOT/othersoftware/flashplayer_standalone/standalone/release/"

popd >/dev/null

echo "Done!  You can now use the run_flashplayer_standalone.sh script."
log_end

echo
read -p "Press enter or wait 10 seconds to continue..." -t 10
echo

