#!/bin/bash

THISSCRIPT="1_install_all_default.sh"
# Copyright (c) 2009 Ryan Pavlik <ryan.pavlik@snc.edu>
# See COPYING.txt for license terms

# Runs the sensible default scripts to install a full setup.

# rp-mt-scripts preamble
# include global functions, load configuration, and start log.
# NOLOGGING="NOLOGGING"
source z_globals.inc  &> /dev/null || source ./scripts/z_globals.inc &> /dev/null
[ $? -ne 0 ] && echo "Cannot find global includes, unzip a fresh copy! Exiting." && exit 1
# end rp-mt-scripts preamble


# array of scripts to run, in order:
SCRIPTS=("install_flashplayer_standalone.sh" "install_tbeta_1.1.sh" "install_pymt_hg.sh")

pushd . > /dev/null
echo
echo "This script will install all sensible defaults for a full multitouch setup."
echo "It will run these install scripts, in this order:"
for SCRIPT in ${SCRIPTS[@]}; do
	echo " - $SCRIPT"
done

echo
echo "Once the installations start, you should not cancel them."
echo "This is your 'last chance' to cancel."
echo "Type 'yes' and press enter to continue, type anything else"
echo "and enter to cancel."
echo
read -p "Do you want to continue? " answer

[ "$answer" != "yes" ] && echo "You didn't type 'yes': No shame in that.  Exiting" && log_append "User canceled at confirmation point" && exit 1

echo
echo "Please enter your password here so that package installation may proceed."
echo "If each action takes less than 15 minutes (expected) this should run un-attended past this point."
sudo -v


INSTALLING=1
for SCRIPT in ${SCRIPTS[@]};do
	if [ $INSTALLING -eq 1 ]; then
		sudo -v
		echo "-----Now running: $SCRIPT"
		log_append_dated "Starting $SCRIPT"
		./$SCRIPT
		RV=$?
		if [ $RV -ne 0 ]; then
			echo "----ERROR running $SCRIPT: returned $RV, so exiting $THISSCRIPT."
			echo "Check the logs, try that one again, then manually run these remaining scripts:"
			log_append_dated "Failed with return value $RV running $SCRIPT - will skip all remaining"
			INSTALLING=0
		else
			echo "----Completed without error return: $SCRIPT"
			log_append_dated "Completed with RV 0: $SCRIPT"		
		fi
	else
		echo "-------Skipped: $SCRIPT"
		log_append "Skipped $SCRIPT due to previous error"
	fi
done

echo "$THISSCRIPT finished."
popd >/dev/null

log_end

echo
read -p "Press enter or wait 10 seconds to continue..." -t 10
echo

