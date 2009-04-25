#!/bin/bash

THISSCRIPT="install_pymt_svn.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Downloads tbeta 1.1 from nuigroup.com, and installs in ~/tbeta-1.1-lin-bin
# then installs packages required for tbeta 1.1 to run on Ubuntu 9.04.
# You also need to use the libpoco workaround scripts.

# include config, global functions, and start log.
# NOLOGGING="NOLOGGING"
source ../z_config.inc

pushd . >/dev/null
echo "Checking out a copy of pymt from version control"
echo "This could take a while..."
sleep 3
mkdir $MTROOT/othersoftware/pymt-svn
cd $MTROOT/othersoftware/pymt-svn
svn checkout http://pymt.googlecode.com/svn/trunk/ pymt
log_append_dated "svn checkout completed"

echo
echo "Now updating apt and installing dependencies from Ubuntu repositories"
echo

sudo aptitude -u -y --with-recommends install python-pyglet python-numpy python-csound
log_append_dated "installed python-pyglet python-numpy python-csound and dependencies"

sudo checkinstall --pkgname=pymt --default --requires="python-pyglet,python-numpy,python-csound" --pakdir=$MTROOT/packages python setup.py install
sudo mv *.deb $MTROOT/packages
sudo mv *.tgz $MTROOT/packages
cd $MTROOT/packages
sudo chown $USERNAME:$USERNAME *.deb
sudo chown $USERNAME:$USERNAME *.tgz

log_end

echo "All done!"

echo
read -p "Press enter or wait 10 seconds to continue..." -t 10
echo

popd
