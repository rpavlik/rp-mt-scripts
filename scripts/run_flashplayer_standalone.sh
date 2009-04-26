#!/bin/bash

THISSCRIPT="run_flashplayer_standalone.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Runs the standalone flashplayer
# set up using these scripts

# rp-mt-scripts preamble
# include global functions, load configuration, and start log.
NOLOGGING="NOLOGGING"
source z_globals.inc  &> /dev/null || source ./scripts/z_globals.inc &> /dev/null
[ $? -ne 0 ] && echo "Cannot find global includes, unzip a fresh copy! Exiting." && exit 1
# end rp-mt-scripts preamble


pushd . > /dev/null

# Detect default tbeta install directory
TBETASUBDIR=$(ls -p $MTROOT/nuigroup/ 2>/dev/null | grep "tbeta.*lin-bin\/$")
DEMODIR="$MTROOT/nuigroup/$TBETASUBDIR/demos"

FLOSC="yes"
PARAM=$1
if [ "$PARAM" = "-f" ]; then
	echo "FLOSC disabled by request"
	log_append "FLOSC disabled by request."
	FLOSC="no"
	PARAM=$2
fi

if [ $FLOSC = "yes" ]; then
	echo "Now starting:	Java-based FLOSC gateway in the background (only needed for flash multitouch)..."
	cd $DEMODIR
	kill $(ps aw |grep "java.*flosc"|head -n 1|grep -o "^ *[0-9]*") > /dev/null
	sleep 1
	./1\)\ Launch\ FLOSC\ Gateway.sh &
	log_append "FLOSC gateway started in background, sleeping briefly and continuing..."
	sleep 3
fi

if [ "$PARAM" != "" ];then
	# we were passed a specific flash file to run
	FLASHFILE=$(readlink -f -n "$(pwd)/$1")
	log_append "attempting to run $FLASHFILE"
	echo "Now starting:	Flash standalone player, running $FLASHFILE"
	cd $(dirname $FLASHFILE)
	[ -f "$FLASHFILE" ] && $MTROOT/othersoftware/flashplayer_standalone/standalone/release/flashplayer $FLASHFILE || echo "$FLASHFILE not found..."
else
	# just run the player
	echo "Now starting:	Flash standalone player"
	log_append "just running the standalone player."
	cd $DEMODIR
	$MTROOT/othersoftware/flashplayer_standalone/standalone/release/flashplayer
fi
log_append_dated "flash player standalone exited"

kill %$(jobs |grep FLOSC|grep -o "\[[0-9]*\]"|grep -o "[0-9]*") > /dev/null
log_append_dated "flash player exited, FLOSC gateway shut down if possible"

log_end
popd >/dev/null
pause_exit


