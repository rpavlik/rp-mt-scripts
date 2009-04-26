#!/bin/bash

THISSCRIPT="1_install_all_default.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Runs the sensible default scripts to install a full setup.

# include config, global functions, and start log.
# NOLOGGING="NOLOGGING"
source ../z_config.inc

pushd . > /dev/null

SCRIPTS=("install_flashplayer_standalone.sh" "install_tbeta_1.1.sh" "install_libpoco_workaround_local.sh" "install_pymt_svn.sh")

echo "Will install all sensible defaults.  Scripts to run:"
for SCRIPT in ${SCRIPTS[@]};do
	echo " - $SCRIPT"
done

read -p "To continue, type the word 'yes' no quotes, and press enter: there is no turning back. " confirm

[ $confirm != "yes" ] && echo "No shame in that.  Exiting" && log_append "User canceled at confirmation point" && exit 1

echo
echo "Please enter your password here so that package installation may proceed."
echo "If each action takes less than 15 minutes (expected) this should run un-attended past this point."
sudo echo


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

