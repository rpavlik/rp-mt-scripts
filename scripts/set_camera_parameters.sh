#!/bin/bash

THISSCRIPT="set_camera_parameters.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Configure the QuickCam Pro 4000 or similar PWC (Phillips) webcams
# for multitouch use:
# Low resolution, high frame rate, automatic things disabled.
# The script will set the options for the last PWC webcam plugged in.

# This script requires that setpwc be installed:
# sudo aptitude install setpwc

# include config, global functions, and start log.
NOLOGGING="NOLOGGING"
source ../z_config.inc

# Grab /dev/video* path of last PWC camera plugged in from the dmesg kernel log
PWCDEVICE=$(dmesg |grep "pwc: Registered as"|tail -n 1|grep -o "\/dev\/video[0-9]*")

if [ -z $PWCDEVICE ]; then
	echo "error: unable to discover PWC device path."
	if [ -z "$(lsmod |grep pwc)" ]; then
		log_append_override "Could not discover device path, but PWC module loaded."
		echo "Weird - you do have the PWC module loaded, though."
		echo "Either the module is loaded without a camera, or the regex needs fixing"
		echo "Dumping some debug info:"
		echo "********* lsmod | grep pwc *********"
		log_append_override "********* lsmod | grep pwc *********"
		lsmod | grep pwc
		log_append_override "$(lsmod | grep pwc)"

		echo
		echo "********* dmesg | grep pwc *********"
		log_append_override "********* dmesg | grep pwc *********"
		dmesg | grep pwc
		log_append_override "$(dmesg | grep pwc)"
		
	else
		log_append_override "Could not discover device path, PWC module not loaded."
		echo "I didn't notice the pwc module loaded, either, so"
		echo "you probably don't have a pwc-based camera and so"
		echo "you don't need/can't use this script."
		echo
		echo "It's possible the module just didn't load when you plugged it in, but"
		echo "that would mean you have a weird system.  I'd bet on the first"
		echo "possibility;go search the internet for your camera model and find"
		echo "what linux driver it uses."
	fi

	echo
	echo "********* good luck! *********"
	exit 1
fi


# set camera params, silently: 
echo "PWC camera connected since last reboot, using device $PWCDEVICE"
echo

setpwc -d $PWCDEVICE  -o 0 -q 0  -S 320,480,30 >& /dev/null

# display params
echo "*****************"
setpwc  -d $PWCDEVICE -p
echo "*****************"
echo
