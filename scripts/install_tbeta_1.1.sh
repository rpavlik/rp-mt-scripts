#!/bin/bash

THISSCRIPT="install_tbeta_1.1.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Downloads tbeta 1.1 from nuigroup.com, and installs in ~/tbeta-1.1-lin-bin
# then installs packages required for tbeta 1.1 to run on Ubuntu 9.04.
# You also need to use the libpoco workaround scripts.

# include config, global functions, and start log.
# NOLOGGING="NOLOGGING"
source ../z_config.inc

if [ -f "$MTROOT/downloads/tbeta-1.1-lin-bin.tar.gz" ]; then
	echo "Apparently found download in $MTROOT/downloads/tbeta-1.1-lin-bin.tar.gz - skipping download"
	log_append "Found what looks like the download at $MTROOT/downloads/tbeta-1.1-lin-bin.tar.gz, skipping download"
else
	echo "Downloading tbeta..."
	echo

	cd $MTROOT/downloads
	wget http://tbeta.nuigroup.com/zip/release/tbeta-1.1-lin-bin.tar.gz
	log_append "Downloaded http://tbeta.nuigroup.com/zip/release/tbeta-1.1-lin-bin.tar.gz to $MTROOT/downloads"
fi

echo "Unzipping tbeta..."
echo
pushd . >/dev/null
cd $MTROOT/nuigroup
tar xzf $MTROOT/downloads/tbeta-1.1-lin-bin.tar.gz
log_append "Unzippped $MTROOT/downloads/tbeta-1.1-lin-bin.tar.gz to $MTROOT/nuigroup/tbeta-1.1-lin-bin"

echo
echo "Now installing dependencies from Ubuntu repositories"
echo



echo "Setting up libpoco, the tbeta problem child..."
sudo aptitude -u -y --with-recommends install libpoco-dev
log_append "Installed libpoco-dev using aptitude, if it wasn't already installed."

echo "Now, you need to either set up a 'fake' version 2 system-wide or"
echo "locally in this install of tbeta."
echo
echo "Use a 'install_libpoco_workaround' script to do this - the local"
echo "method is probably the safer, smarter one, but only works for that"
echo "specific copy of tbeta.  If in doubt, use the local script."

log_end


echo
read -p "Press enter or wait 10 seconds to continue..." -t 10
echo

popd
