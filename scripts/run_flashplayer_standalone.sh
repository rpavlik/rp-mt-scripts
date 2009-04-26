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

if [ "$1" != "" ];then
	# we were passed a specific flash file to run
	FLASHFILE=$(readlink -f -n "$(pwd)/$1")
	log_append "attempting to run $FLASHFILE"
	cd $(dirname $FLASHFILE)
	[ -f "$FLASHFILE" ] && $MTROOT/othersoftware/flashplayer_standalone/standalone/release/flashplayer $FLASHFILE || echo "$FLASHFILE not found..."
else
	# just run the player
	log_append "just running the standalone player."
	cd $MTROOT/othersoftware/flashplayer_standalone/standalone/release
	./flashplayer
fi

log_append_dated "flash player standalone exited"

log_end
popd >/dev/null
pause_exit


