#!/bin/bash

THISSCRIPT="update_pymt_hg.sh"
# Copyright (c) 2009 Ryan Pavlik <ryan.pavlik@snc.edu>
# See COPYING.txt for license terms

# Update a mercurial checkout of pymt, and
# build a new debian package of it.  If using a new system,
# first run the install_pymt_from_hg script

# Completed, basic-quality (aka, don't send them in to Ubuntu)
# packages will be in ~/packages along with a backup file made
# by checkinstall

# rp-mt-scripts preamble
# include global functions, load configuration, and start log.
# NOLOGGING="NOLOGGING"
source z_globals.inc  &> /dev/null || source ./scripts/z_globals.inc &> /dev/null
[ $? -ne 0 ] && echo "Cannot find global includes, unzip a fresh copy! Exiting." && exit 1
# end rp-mt-scripts preamble

pushd . > /dev/null

echo "Starting PyMT (from Mercurial version control) update script..."
# request password now, for later installs.
sudo -v

echo "Running hg pull - this could take a while"
cd $MTROOT/othersoftware/pymt-hg/pymt/
hg pull -u | tee $MTROOT/logs/$DATESTAMP.pymt-hg-log.log
hg identify >> $MTROOT/logs/$DATESTAMP.pymt-hg-log.log
HGREVISION=$(hg identify | tail -n 1  |grep -o "[0-9a-f]*")
PKGVERSION="0.0.hg.$(date +%Y%m%d%H%M%S).r$HGREVISION"
log_append "hg pull completed"

echo
echo "Removing old PyMT..."
sudo aptitude remove pymt
sudo python setup.py clean
log_append "old package removed, setup.py clean completed."

echo
echo "Installing new PyMT.."
sudo checkinstall --pkgname=pymt --pkgversion=$PKGVERSION --pkgrelease="" --default --requires="python-pyglet,python-numpy,python-csound" --maintainer="hg using rp-mt-scripts" --pakdir=$MTROOT/packages --fstrans=no python setup.py install
log_append_dated "new package built and installed"
sudo mv *.deb $MTROOT/packages
sudo mv *.tgz $MTROOT/packages
cd $MTROOT/packages
sudo chown $USERNAME:$USERNAME *.deb
sudo chown $USERNAME:$USERNAME *.tgz

echo
echo "PyMT (from hg) update completed!"
echo "You can now run your own PyMT apps or start the included demos with:"
echo "    ./run_pymt_hg_examples.sh"
echo "from inside the 'scripts' directory."

log_end
popd >/dev/null
pause_exit
