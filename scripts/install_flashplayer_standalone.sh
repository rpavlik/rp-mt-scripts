#!/bin/bash

THISSCRIPT="install_flashplayer_standalone.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Sets up config file for all scripts in this directory to
# share with each other.

source ../z_config.inc

http://www.adobe.com/support/flashplayer/downloads.html
http://download.macromedia.com/pub/flashplayer/updaters/10/flash_player_10_linux_dev.tar.gz

cat > $MTROOT/scriptlogs/$DATESTAMP.$THISSCRIPT.log <<heredoc
$DATESTAMP.$THISSCRIPT.log
$(uname -a)

Actions
-------
Ran script

heredoc

echo
read -p "Press enter or wait 10 seconds to continue..." -t 10
echo

