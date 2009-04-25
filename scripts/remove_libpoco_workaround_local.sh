#!/bin/bash

THISSCRIPT="remove_libpoco_workaround_local.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Remove symlinks in the tbeta directory required for tbeta 1.1
# Reverses what install_libpoco_workaround_local.sh does

# include config, global functions, and start log.
# NOLOGGING="NOLOGGING"
source ../z_config.inc

echo "Removing symlinks to libPoco*.so.2 from a tbeta install"
echo "set up with these scripts ('local')"
echo 

rm $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libPocoFoundation.so.2
log_append "rm $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libPocoFoundation.so.2 completed"

rm $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libPocoUtil.so.2
log_append "rm $MTROOT/nuigroup/tbeta-1.1-lin-bin/tbeta/libs/libPocoUtil.so.2 completed"

log_end

echo 
echo "tbeta will not run until a workaround is installed again or "
echo "they put out a newer build linking against newer libraries."
