#!/bin/bash

# remove_libpoco_workaround_global.sh
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Remove system-wide symlinks for tbeta 1.1
# Reverses what install_libpoco_workaround_global.sh does

echo "Removing global symlinks to libPoco*.so.2 for tbeta"
echo 

sudo rm /usr/lib/libPocoFoundation.so.2
sudo rm /usr/lib/libPocoUtil.so.2

echo
echo "tbeta will not run until a workaround is installed again or "
echo "they put out a newer build linking against newer libraries."
