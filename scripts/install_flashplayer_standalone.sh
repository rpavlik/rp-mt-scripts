#!/bin/bash

THISSCRIPT="install_flashplayer_standalone.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Downloads and installs the standalone flash player.

# include config, global functions, and start log.
# NOLOGGING="NOLOGGING"
source z_globals.inc

pushd . > /dev/null

cat > $MTROOT/downloads/install_flashplayer_standalone_security.html <<heredoc
<html><body>
<h1>install_flashplayer.standalone.sh - Flash Security Step</h1>
<p>You need to add $MTROOT/nuigroup/tbeta-1.1-lin-bin/demos/ to the global security settings in the popup window.  Also add any other directories you might store multitouch flash files in.</p>
<script>
window.open("http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager04.html" width="100%" height="400px")
</script>
<p><strong><a href="http://www.macromedia.com/support/documentation/en/flashplayer/help/settings_manager04.html" target="_new">Open flash security manager in new window</a></strong></p>

</body></html>
heredoc

if [ -d "$MTROOT/othersoftware/flashplayer_standalone" ]; then
	echo "Skipping installation of flash player standalone..."
	echo "Apparently already installed in $(readlink -f -n $MTROOT/othersoftware/flashplayer_standalone)"
	echo "Showing the security setting page anyway in case it needs updating."
	sensible-browser "$MTROOT/downloads/install_flashplayer_standalone_security.html"
	exit
fi

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



sensible-browser "$MTROOT/downloads/install_flashplayer_standalone_security.html"

echo "Done!  Once you finish the security settings in the opened web browser, you can use the run_flashplayer_standalone.sh script."
log_end
popd >/dev/null
pause_exit

