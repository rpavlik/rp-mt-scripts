#!/bin/bash

THISSCRIPT="old_run_pymt_svn_examples.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Runs the examples launcher from a pymt install
# set up using these scripts

# rp-mt-scripts preamble
# include global functions, load configuration, and start log.
NOLOGGING="NOLOGGING"
source z_globals.inc  &> /dev/null || source ./scripts/z_globals.inc &> /dev/null
[ $? -ne 0 ] && echo "Cannot find global includes, unzip a fresh copy! Exiting." && exit 1
# end rp-mt-scripts preamble


pushd . > /dev/null

cd $MTROOT/othersoftware/pymt-svn/pymt/examples

if [ "$1" != ""  -a -d "$MTROOT/othersoftware/pymt-svn/pymt/examples/$1" ]; then
	# we were passed a specific example to run
	echo "Attempting to run: example $1"
	cd $1
	log_append "attempting to run $1/$1.py"
	[ -f "$1.py" ] && python "$1.py" || echo "Can't figure out the .py to run in $1, sorry..."
else
	# just run the launcher
	log_append "just running the example launcher."
	echo "Starting the PyMT Examples launcher desktop..."
	./launcher.py
fi

log_append_dated "pymt example exited"

log_end
popd >/dev/null
pause_exit


