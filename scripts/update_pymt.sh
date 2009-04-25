#!/bin/bash

THISSCRIPT="update_pymt.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Update a subversion checkout of pymt, and
# build a new debian package of it.  If using a new system,
# first run the install_pymt_from_svn script

# Completed, basic-quality (aka, don't send them in to Ubuntu)
# packages will be in ~/packages along with a backup file made
# by checkinstall

# include config, global functions, and start log.
# NOLOGGING="NOLOGGING"
source ../z_config.inc

echo "Updating pymt from subversion, please wait..."
cd $MTROOT/othersoftware/pymt-svn/pymt/
svn up
log_append "svn up completed"
sudo aptitude remove pymt
sudo python setup.py clean
log_append "old package removed, setup.py clean completed."

sudo checkinstall --pkgname=pymt --default --requires="python-pyglet,python-numpy,python-csound" --pakdir=$MTROOT/packages/ python setup.py install
log_append_dated "new package built and installed"
sudo mv *.deb $MTROOT/packages
sudo mv *.tgz $MTROOT/packages
cd $MTROOT/packages
sudo chown $USERNAME:$USERNAME *.deb
sudo chown $USERNAME:$USERNAME *.tgz
log_end

echo "pymt update completed!"
