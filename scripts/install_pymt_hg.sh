#!/bin/bash

THISSCRIPT="install_pymt_hg.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Downloads pymt from mercurial source control and builds a package from it
# using checkinstall.

# rp-mt-scripts preamble
# include global functions, load configuration, and start log.
# NOLOGGING="NOLOGGING"
source z_globals.inc  &> /dev/null || source ./scripts/z_globals.inc &> /dev/null
[ $? -ne 0 ] && echo "Cannot find global includes, unzip a fresh copy! Exiting." && exit 1
# end rp-mt-scripts preamble

pushd . >/dev/null

if [ -d "$MTROOT/othersoftware/pymt-hg/pymt" ]; then
	echo "Skipping installation of pymt from hg, running update instead."
	echo "Apparently already installed in $(readlink -f -n $MTROOT/othersoftware/pymt-hg/pymt)"
	sleep 5
	cd $MTROOT/scripts
	./update_pymt_hg.sh
	exit $?
fi
echo "Installing pymt from hg..."
sudo -v

echo "First, installing dependencies (to build and run) from Ubuntu repositories"
sudo aptitude -y --with-recommends install mercurial checkinstall python-pyglet python-numpy python-csound python-liblo 
log_append_dated "installed mercurial checkinstall python-pyglet python-numpy python-csound and dependencies"

echo "Checking out a copy of pymt from version control"
echo "This could take a while..."
sleep 3
mkdir $MTROOT/othersoftware/pymt-hg
cd $MTROOT/othersoftware/pymt-hg
hg clone http://pymt.googlecode.com/hg/ pymt | tee $MTROOT/logs/$DATESTAMP.pymt-hg-log.log
hg tip >> $MTROOT/logs/$DATESTAMP.pymt-hg-log.log
HGREVISION=$(hg tip | head -n 1  |grep -o "[0-9a-f]*^")
PKGVERSION="0.0.hg.$(date +%Y%m%d%H%M%S).r$HGREVISION"
log_append_dated "hg checkout completed"

cd $MTROOT/othersoftware/pymt-hg/pymt

sudo checkinstall --pkgname=pymt --pkgversion=$PKGVERSION --pkgrelease="1" --default --requires="python-pyglet,python-numpy" --maintainer="hg using rp-mt-scripts" --pakdir=$MTROOT/packages python setup.py install

sudo mv *.deb $MTROOT/packages
sudo mv *.tgz $MTROOT/packages
cd $MTROOT/packages
sudo chown $USERNAME:$USERNAME *.deb
sudo chown $USERNAME:$USERNAME *.tgz

echo "All done!"

log_end
popd >/dev/null
pause_exit
