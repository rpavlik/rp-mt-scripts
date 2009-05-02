#!/bin/bash

THISSCRIPT="install_tbeta_1.1.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Downloads tbeta 1.1 from nuigroup.com, and installs in ~/tbeta-1.1-lin-bin
# then installs packages required for tbeta 1.1 to run on Ubuntu 9.04.
# You also need to use the libpoco workaround scripts.

# rp-mt-scripts preamble
# include global functions, load configuration, and start log.
# NOLOGGING="NOLOGGING"
source z_globals.inc  &> /dev/null || source ./scripts/z_globals.inc &> /dev/null
[ $? -ne 0 ] && echo "Cannot find global includes, unzip a fresh copy! Exiting." && exit 1
# end rp-mt-scripts preamble

if [ -d "$MTROOT/nuigroup/tbeta-1.1-lin-bin" ]; then
	echo "Skipping installation of tbeta 1.1..."
	echo "Apparently already installed in $(readlink -f -n $MTROOT/nuigroup/tbeta-1.1-lin-bin)"
	exit
fi

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
mkdir $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/old
log_append "Unzippped $MTROOT/downloads/tbeta-1.1-lin-bin.tar.gz to $MTROOT/nuigroup/tbeta-1.1-lin-bin"

echo
echo "Now installing dependencies from Ubuntu repositories"
echo

sudo aptitude -y -q --with-recommends install freeglut3 freeglut3-dev libglu1-mesa-dev libraw1394-8 libxxf86vm1 libz1g

echo " - opencv: "
sudo aptitude -y -q --with-recommends install libcv-dev libcvaux-dev
if [ "$(is_installed libcv1)" != "" ]; then
	echo "succeeded, moving aside bundled version in tbeta"
	mv $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libcv.* $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/old/
	log_append "Moved aside bundled libcv.* in favor of ubuntu versions"
	mv $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libcxcore.* $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/old/
	log_append "Moved aside bundled libcxcore.* in favor of ubuntu versions"
else
	echo "not successful - tbeta will use its bundled version"
fi

echo " - v4l: "
sudo aptitude -y -q --with-recommends install libv4l-0
if [ "$(dpkg -s libv4l-0| grep -o install\ ok)" = "install ok" ]; then
	echo "succeeded, moving aside bundled version in tbeta"
	mv $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libv4l.* $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/old/
	log_append "Moved aside bundled libv4l.* in favor of ubuntu versions"
	mv $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libv4l2.* $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/old/
	log_append "Moved aside bundled libv4l2.* in favor of ubuntu versions"	
else
	echo "not successful - tbeta will use its bundled version"
fi

echo " - freetype: "
sudo aptitude -y -q --with-recommends install libfreetype6-dev
if [ "$(dpkg -s libfreetype6-dev| grep -o install\ ok)" = "install ok" ]; then
	echo "succeeded, moving aside bundled version in tbeta"
	mv $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libfreetype.* $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/old/
	log_append "Moved aside bundled libfreetype.* in favor of ubuntu versions"
else
	echo "not successful - tbeta will use its bundled version"
fi

echo " - freeimage: "
sudo aptitude -y -q --with-recommends install libfreeimage-dev
if [ "$(dpkg -s libfreeimage-dev| grep -o install\ ok)" = "install ok" ]; then
	echo "succeeded, moving aside bundled version in tbeta"
	mv $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libfreeimage* $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/old/
	log_append "Moved aside bundled libfreeimage* in favor of ubuntu versions"
else
	echo "not successful - tbeta will use its bundled version"
fi

echo " - swscale: "
sudo aptitude -y -q --with-recommends install libswscale-dev
if [ "$(dpkg -s libswscale6-dev| grep -o install\ ok)" = "install ok" ]; then
	echo "succeeded, moving aside bundled version in tbeta"
	mv $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libswscale.* $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/old/
	log_append "Moved aside bundled libswscale.* in favor of ubuntu versions"
else
	echo "not successful - tbeta will use its bundled version"
fi

echo " - avutil: "
sudo aptitude -y -q --with-recommends install libavutil-dev
if [ "$(dpkg -s libavutil6-dev| grep -o install\ ok)" = "install ok" ]; then
	echo "succeeded, moving aside bundled version in tbeta"
	mv $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libavutil.* $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/old/
	log_append "Moved aside bundled libswscale.* in favor of ubuntu versions"
else
	echo "not successful - tbeta will use its bundled version"
fi

echo "Setting up libpoco, the tbeta problem child..."
sudo aptitude -y --with-recommends install libpoco-dev
log_append "Installed libpoco-dev using aptitude, if it wasn't already installed."

echo "Now, you need to either set up a 'fake' version 2 system-wide or"
echo "locally in this install of tbeta."
echo
echo "Use a 'install_libpoco_workaround' script to do this - the local"
echo "method is probably the safer, smarter one, but only works for that"
echo "specific copy of tbeta.  If in doubt, use the local script."

log_end
popd >/dev/null
pause_exit
