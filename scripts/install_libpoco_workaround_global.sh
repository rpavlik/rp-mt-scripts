#!/bin/bash

THISSCRIPT="install_libpoco_workaround_global.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Create system-wide symlinks to allow tbeta 1.1 to install on
# ubuntu 9.04 - you might need to change the libpoco so names
# to something else for later distribution versions, or change 2 to
# something else as requested by tbeta when starting

# rp-mt-scripts preamble
# include global functions, load configuration, and start log.
# NOLOGGING="NOLOGGING"
source z_globals.inc  &> /dev/null || source ./scripts/z_globals.inc &> /dev/null
[ $? -ne 0 ] && echo "Cannot find global includes, unzip a fresh copy! Exiting." && exit 1
# end rp-mt-scripts preamble

echo "Creating global symlinks to libPoco*.so.2 for tbeta 1.1"
sudo -v
echo


sudo ln -s /usr/lib/libPocoFoundation.so /usr/lib/libPocoFoundation.so.2
log_append "sudo ln -s /usr/lib/libPocoFoundation.so /usr/lib/libPocoFoundation.so.2 completed"
sudo ln -s /usr/lib/libPocoUtil.so /usr/lib/libPocoUtil.so.2
log_append "sudo ln -s /usr/lib/libPocoUtil.so /usr/lib/libPocoUtil.so.2 completed"

echo
echo "If tbeta doesn't run now, look at this script source for how to"
echo "fix it if you get a libPoco error."
echo
echo "tBeta install and workaround completed!"
echo "Now you can start tbeta with:"
echo "    ./run_tbeta_1.1.sh"
echo "from inside the 'scripts' directory."

log_end
pause_exit
