#!/bin/bash

# remove_libpoco_workaround_local.sh
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Remove symlinks in the tbeta directory required for tbeta 1.1
# Reverses what install_libpoco_workaround_local.sh does

echo "Removing symlinks to libPoco*.so.2 from a tbeta install"
echo "unzipped in ~/tbeta-1.1-lin-bin"
echo 

rm ~/tbeta-1.1-lin-bin/tbeta/libs/libPocoFoundation.so.2
rm ~/tbeta-1.1-lin-bin/tbeta/libs/libPocoUtil.so.2

echo 
echo "tbeta will not run until a workaround is installed again or "
echo "they put out a newer build linking against newer libraries."
