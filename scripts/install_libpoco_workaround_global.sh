#!/bin/bash

# install_libpoco_workaround_global.sh
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Create system-wide symlinks to allow tbeta 1.1 to install on
# ubuntu 9.04 - you might need to change the libpoco so names
# to something else for later distribution versions, or change 2 to
# something else as requested by tbeta when starting

source ../z_config.inc

echo "Creating global symlinks to libPoco*.so.2 for tbeta 1.1"
echo

sudo ln -s /usr/lib/libPocoFoundation.so /usr/lib/libPocoFoundation.so.2
sudo ln -s /usr/lib/libPocoUtil.so /usr/lib/libPocoUtil.so.2

echo
echo "If tbeta doesn't run now, look at this script source for how to"
echo "fix it if you get a libPoco error."
echo
echo "To run tbeta, I recommend using the run_tbeta.sh script in this"
echo "directory to set up a QuickCam Pro 4000 then execute tbeta, otherwise"
echo "you can cd ~/tbeta-1.1-lin-bin/tbeta  and ./Launch\ tbeta.sh"

cat > $MTROOT/scriptlogs/$DATESTAMP.$THISSCRIPT.log <<heredoc
$DATESTAMP.$THISSCRIPT.log
$(uname -a)

Actions
-------
Ran script

heredoc

echo
read -p "Press enter or wait 10 seconds to continue..." -t 10
echo
