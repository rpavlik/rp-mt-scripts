#!/bin/bash

# install_libpoco_workaround_local.sh
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Create symlinks in the tbeta directory to allow tbeta 1.1 to install on
# ubuntu 9.04 - you might need to change the libpoco so names
# to something else for later distribution versions, or change 2 to
# something else as requested by tbeta when starting

# include config, global functions, and start log.
# NOLOGGING="NOLOGGING"
source ../z_config.inc

echo "Creating symlinks to libPoco*.so.2 in a tbeta 1.1 install"
echo "set up with these scripts ('local')"
echo 

ln -s /usr/lib/libPocoFoundation.so $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libPocoFoundation.so.2
log_append "ln -s /usr/lib/libPocoFoundation.so $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libPocoFoundation.so.2 completed"

ln -s /usr/lib/libPocoUtil.so $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libPocoUtil.so.2
log_append "ln -s /usr/lib/libPocoUtil.so $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libPocoUtil.so.2 completed"

echo 
echo "If tbeta doesn't run now, look at this script source for how to"
echo "fix it if you get a libPoco error."
echo
echo "To run tbeta, use the run_tbeta.sh script in this"
echo "directory to set up a QuickCam Pro 4000 then execute tbeta"

log_end

echo
read -p "Press enter or wait 10 seconds to continue..." -t 10
echo
