#!/bin/bash

THISSCRIPT="run_tbeta.sh"
# Copyright (c) 2009 Ryan Pavlik <ryan.pavlik@snc.edu>
# See COPYING.txt for license terms

# Sets up a quickcam pro 4000 and runs tbeta as installed by another
# script in this package or at the path passed to the script.

# rp-mt-scripts preamble
# include global functions, load configuration, and start log.
# NOLOGGING="NOLOGGING"
source z_globals.inc  &> /dev/null || source ./scripts/z_globals.inc &> /dev/null
[ $? -ne 0 ] && echo "Cannot find global includes, unzip a fresh copy! Exiting." && exit 1
# end rp-mt-scripts preamble


if [ "$1" = "--help" -o   "$1" = "-h" ]; then 
	echo "Usage:"
	echo "$0 -h, --help	show this message"
	echo "$0 [-f] [tbeta_dir]	start tbeta from this script system or tbeta_dir "
	echo "				(runs binaries in tbeta_dir/tbeta/ tbeta_dir/demos/)"
	echo
	echo "Options:"
	echo "-F			Start FLOSC gateway for flash/AS3 multi-touch"

	exit
fi

# sudo only needed in set_camera_parameters for setpwc if something strange happens.
# sudo -v

FLOSC="no"
pushd . > /dev/null
# Detect default tbeta install directory
TBETASUBDIR=$(ls -p $MTROOT/nuigroup/ 2>/dev/null | grep "tbeta.*lin-bin\/$")
TBETADIR="$MTROOT/nuigroup/$TBETASUBDIR"

if [ "$1" = "-F" ]; then
	echo "FLOSC enabled by request"
	log_append "FLOSC enabled by request."
	FLOSC="yes"
	if [ -n "$2" ]; then
		echo "Using specified tbeta directory: $2"
		log_append "Custom directory for tbeta specified: $2"
		TBETADIR="$2"
	fi
else
	if [ -n "$1" ]; then
		echo "Using specified tbeta directory: $1"
		log_append "Custom directory for tbeta specified: $2"
		TBETADIR="$1"
	fi
fi

TBETADIR=$(readlink -f $TBETADIR)

if [ ! -f "$TBETADIR/tbeta/tbeta" ]; then
	echo "tbeta not found... did you install it using these scripts?"
	echo "tbeta directory: $TBETADIR"
	log_append "could not find $TBETADIR/tbeta/tbeta so exiting with error code 1!"
	exit 1
fi

echo 
echo "*****************"
echo 
echo "Setting up your camera using set_camera_parameters.sh"
echo 

$MTROOT/scripts/set_camera_parameters.sh > /dev/null

echo 
echo ""
if [ $FLOSC = "yes" ]; then
	echo "Now starting:	Java-based FLOSC gateway in the background (only needed for flash multitouch)..."
	cd $TBETADIR/demos
	kill $(ps aw |grep "java.*flosc"|head -n 1|grep -o "^ *[0-9]*") &> /dev/null
	./1\)\ Launch\ FLOSC\ Gateway.sh &
	log_append "FLOSC gateway started in background, sleeping briefly and continuing..."
	sleep 3

fi
echo "Now starting:	tbeta..."

echo
echo "If you are starting a multitouch app, be sure to press space in tbeta"
echo "to change it to minimal mode for better performance."
echo "You can exit tbeta by pressing Esc."
echo 
echo "*****************"
echo

cd $TBETADIR/tbeta/
export LD_LIBRARY_PATH=$(pwd)/libs/
./tbeta
TBETARV=$?
log_append "tbeta started for the first time."

until [ $TBETARV -ne 139 ]; do
	echo 
	echo "*****************"
	echo
	log_append_dated "tbeta crashed with a segfault!"
	read -p "Not my fault - tbeta crashed.  Restarting in 10 seconds, press enter to cancel..." -t 10
	RRV=$?
	if [ $RRV -eq 0 ]; then
		echo "User chose to exit instead of restart crashed tbeta."
		log_append_dated "User chose to exit instead of restart crashed tbeta."
		echo "Shutting down FLOSC gateway and quitting..."
		kill %$(jobs |grep FLOSC|grep -o "\[[0-9]*\]"|grep -o "[0-9]*") &> /dev/null
		log_append_dated "Attempted to shut down FLOSC gateway, now exiting with error code 1"
		exit 1
	fi

	echo 
	echo "*****************"
	echo "Restarting tbeta..."
	log_append_dated "tbeta relaunched"
	export LD_LIBRARY_PATH=$(pwd)/libs/
	./tbeta
	TBETARV=$?
done

if [ $TBETARV -ne 0 ]; then
	echo "tbeta exited with error code ($TBETARV) but did not crash.  Exiting."
	log_append_dated "tbeta exited with error code ($TBETARV) but did not crash.  Exiting."
	echo "If tbeta did not start, you probably need to run the libpoco workaround"
fi

kill $(jobs |grep FLOSC|grep -o "\[[0-9]*\]"|grep -o "[0-9]*") > /dev/null
log_append_dated "tbeta exited, FLOSC gateway shut down if possible"


echo 
echo "*****************"
echo "tbeta terminated, FLOSC gateway shutdown."
log_end
popd >/dev/null
pause_exit


