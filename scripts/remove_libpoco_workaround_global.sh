#!/bin/bash

THISSCRIPT="remove_libpoco_workaround_global.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Remove system-wide symlinks for tbeta 1.1
# Reverses what install_libpoco_workaround_global.sh does

# include config, global functions, and start log.
# NOLOGGING="NOLOGGING"
source ../z_config.inc

echo "Removing global symlinks to libPoco*.so.2 for tbeta"
echo 

sudo rm /usr/lib/libPocoFoundation.so.2
log_append "sudo rm /usr/lib/libPocoFoundation.so.2 completed"

sudo rm /usr/lib/libPocoUtil.so.2
log_append "sudo rm /usr/lib/libPocoUtil.so.2 completed"

log_end

echo
echo "tbeta will not run until a workaround is installed again or "
echo "they put out a newer build linking against newer libraries."
