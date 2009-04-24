#!/bin/bash

# run_tbeta_1.1.sh
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Sets up a quickcam pro 4000 and runs tbeta as installed by another
# script in this package or at the path passed to the script.

# Configuration:

# MTROOT should be the same between all 
MTROOT="$HOME/multitouch"


if [ "$1" = "--help" -o   "$1" = "--help" ]; then 
	echo "Usage:"
	echo "$0 -h, --help	show this message"
	echo "$0 [-n] [tbeta_dir]	start tbeta from ~/tbeta-1.1-lin-bin/ or tbeta_dir "
	echo "				(runs binary in tbeta_dir/tbeta/ tbeta_dir/demos/)"
	echo
	echo "Options:"
	echo "-f			Do not start FLOSC gateway for flash/AS3 multi-touch"

	exit
fi

FLOSC="yes"

# Detect default tbeta install directory
TBETASUBDIR=$(ls -p $MTROOT 2>/dev/null | grep "tbeta.*lin-bin\/$")
TBETADIR="$MTROOT/$TBETASUBDIR"

echo $TBETADIR

exit
if [ "$1" = "-n" ]; then
	echo "FLOSC disabled by request"
	FLOSC="no"
	if [ -n "$2" ]; then
		echo "Using specified tbeta directory: $2"
		TBETADIR="$2"
	fi
else
	if [ -n "$1" ]; then
		echo "Using specified tbeta directory: $1"
		TBETADIR="$1"
	fi
fi

if [ ! -f "$TBETADIR/tbeta/Launch\ tbeta.sh" ]; then
	echo "tbeta not found in default location

echo 
echo "*****************"
echo 
echo "Setting up your camera using set_camera_parameters.sh"
echo "That script comes by default set up for a QuickCam Pro 4000"
echo "or other camera using the 'pwc' module -sets to 320x480, 30FPS"
echo 

./set_camera_parameters.sh > /dev/null

echo 
echo "Now starting:"
if [ $FLOSC = "yes" ]; then
	echo "	Java-based FLOSC gateway in the background (for flash multitouch)"
fi
echo "	tbeta unzipped to ~/tbeta-1.1-lin-bin or specified location"
echo "If tbeta does not start, you probably need to run the libpoco workaround"
echo
echo "If you are starting a multitouch app, be sure to press space in tbeta"
echo "to change it to minimal mode for better performance."
echo "You can exit tbeta by pressing Esc."
echo 
echo "*****************"
echo
pushd .
cd $TBETADIR
pwd
cd demos
if [ $FLOSC = "yes" ]; then
	./1\)\ Launch\ FLOSC\ Gateway.sh &
fi

cd ../tbeta/
./Launch\ tbeta.sh
TBETARV=$?
	until [ $TBETARV -ne 139 ]; do
	echo 
	echo "*****************"
	echo
	read -p "Not my fault - tbeta crashed.  Restarting in 10 seconds, press enter to cancel..." -t 10

	if [ $? -eq 0 ]; then
		echo "User chose to exit instead of restart crashed tbeta."
		echo "Shutting down FLOSC gateway and quitting..."
		kill %$(jobs |grep FLOSC|grep -o "\[[0-9]*\]"|grep -o "[0-9]*") > /dev/null
		exit 1
	fi

	echo 
	echo "*****************"
	echo "Restarting tbeta..."
	./Launch\ tbeta.sh
	TBETARV=$?
done

if [ $TBETARV -ne 0 ]; then
	echo "tbeta exited with error code ($TBETARV) but did not crash.  Exiting."
fi

kill %$(jobs |grep FLOSC|grep -o "\[[0-9]*\]"|grep -o "[0-9]*") > /dev/null

echo 
echo "*****************"
echo "tbeta terminated, FLOSC gateway shutdown."
popd


