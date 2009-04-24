#!/bin/bash

# update_pymt.sh
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Update a subversion checkout of pymt, and
# build a new debian package of it.  If using a new system,
# first run the install_pymt_from_svn script

# Completed, basic-quality (aka, don't send them in to Ubuntu)
# packages will be in ~/packages along with a backup file made
# by checkinstall



cd ~/src/pymt-svn/pymt/
svn up
sudo aptitude remove pymt
sudo python setup.py clean
echo
echo "********"
echo "Make sure the package name is 'pymt'!"
echo "********"
echo

sudo checkinstall --pakdir=$HOME/packages python setup.py install
sudo mv *.tgz $HOME/packages
cd ~/packages
sudo chown $USERNAME:$USERNAME *.deb
sudo chown $USERNAME:$USERNAME *.tgz


