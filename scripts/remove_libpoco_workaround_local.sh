#!/bin/bash

THISSCRIPT="remove_libpoco_workaround_local.sh"
# Copyright (c) 2009 Ryan Pavlik <ryan.pavlik@snc.edu>
# See COPYING.txt for license terms

# Remove symlinks in the tbeta directory required for tbeta 1.1
# Reverses what install_libpoco_workaround_local.sh does

# rp-mt-scripts preamble
# include global functions, load configuration, and start log.
# NOLOGGING="NOLOGGING"
source z_globals.inc  &> /dev/null || source ./scripts/z_globals.inc &> /dev/null
[ $? -ne 0 ] && echo "Cannot find global includes, unzip a fresh copy! Exiting." && exit 1
# end rp-mt-scripts preamble

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
