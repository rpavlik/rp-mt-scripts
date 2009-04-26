#!/bin/bash

THISSCRIPT="run_flashplayer_standalone.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Runs the standalone flashplayer
# set up using these scripts

# include config, global functions, and start log.
# NOLOGGING="NOLOGGING"
source z_globals.inc


pushd . > /dev/null

cd $MTROOT/othersoftware/flashplayer_standalone/standalone/release

if [ "$1" != "" ];then
	# we were passed a specific flash file to run
	FLASHFILE="$(readlink -f -n $(pwd)/$1)"
	log_append "attempting to run $FLASHFILE"
	[ -f "$FLASHFILE" ] && ./flashplayer $FLASHFILE || echo "$FLASHFILE not found..."
else
	# just run the player
	log_append "just running the standalone player."
	./flashplayer
fi

log_append_dated "flash player standalone exited"

log_end
popd >/dev/null
pause_exit


