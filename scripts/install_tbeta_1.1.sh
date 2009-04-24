#!/bin/bash

# install_tbeta_1.1.sh
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Downloads tbeta 1.1 from nuigroup.com, and installs in ~/tbeta-1.1-lin-bin
# then installs packages required for tbeta 1.1 to run on Ubuntu 9.04.
# You also need to use the libpoco workaround scripts.

echo "Downloading and installing tbeta..."
echo
pushd .
cd ~
wget http://tbeta.nuigroup.com/zip/release/tbeta-1.1-lin-bin.tar.gz
tar xzf tbeta-1.1-lin-bin.tar.gz
rm tbeta-1.1-lin-bin.tar.gz

echo
echo "Now installing dependencies from Ubuntu repositories"
echo



echo "Setting up libpoco, the tbeta problem child..."
sudo aptitude install libpoco-dev

echo "Now, you need to either set up a 'fake' version 2 system-wide or"
echo "locally in one install of tbeta unzipped to ~/tbeta-1.1-lin-bin"
echo "which is where this script installed tbeta."
echo
echo "Use a 'install_libpoco_workaround' script to do this - the local"
echo "method is probably the safer, smarter one, but only works for that"
echo "specific copy of tbeta."

echo
read -p "Press enter or wait 10 seconds to continue..." -t 10
echo

popd
