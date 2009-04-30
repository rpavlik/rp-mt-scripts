#!/bin/bash

THISSCRIPT="old_install_pymt_svn.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Downloads pymt from svn source control and builds a package from it
# using checkinstall.

# rp-mt-scripts preamble
# include global functions, load configuration, and start log.
# NOLOGGING="NOLOGGING"
source z_globals.inc  &> /dev/null || source ./scripts/z_globals.inc &> /dev/null
[ $? -ne 0 ] && echo "Cannot find global includes, unzip a fresh copy! Exiting." && exit 1
# end rp-mt-scripts preamble

pushd . >/dev/null

if [ -d "$MTROOT/othersoftware/pymt-svn/pymt" ]; then
	echo "Skipping installation of pymt from svn, running update instead."
	echo "Apparently already installed in $(readlink -f -n $MTROOT/othersoftware/pymt-svn/pymt)"
	sleep 5
	cd $MTROOT/scripts
	./update_pymt.sh
	exit $?
fi
echo "Installing pymt from svn..."
sudo -v

echo "First, installing dependencies (to build and run) from Ubuntu repositories"
sudo aptitude -y --with-recommends install subversion checkinstall python-pyglet python-numpy python-csound python-liblo
log_append_dated "installed subversion checkinstall python-pyglet python-numpy python-csound and dependencies"

echo "Checking out a copy of pymt from version control"
echo "This could take a while..."
sleep 3
mkdir $MTROOT/othersoftware/pymt-svn
cd $MTROOT/othersoftware/pymt-svn
svn checkout http://pymt.googlecode.com/svn/trunk/ pymt | tee $MTROOT/logs/$DATESTAMP.pymt-svn-log.log
SVNREVISION=$(tail -n 1 $MTROOT/logs/$DATESTAMP.pymt-svn-log.log |grep -o "[0-9]*")
PKGVERSION="0.0.$SVNREVISION"
log_append_dated "svn checkout completed"

cd $MTROOT/othersoftware/pymt-svn/pymt

sudo checkinstall --pkgname=pymt --pkgversion=$PKGVERSION --pkgrelease="$(date +%Y%m%d%H%M%S)" --default --requires="python-pyglet,python-numpy" --maintainer="svn using rp-mt-scripts" --pakdir=$MTROOT/packages python setup.py install

sudo mv *.deb $MTROOT/packages
sudo mv *.tgz $MTROOT/packages
cd $MTROOT/packages
sudo chown $USERNAME:$USERNAME *.deb
sudo chown $USERNAME:$USERNAME *.tgz

echo "All done!"

log_end
popd >/dev/null
pause_exit
