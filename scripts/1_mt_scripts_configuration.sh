#!/bin/bash

THISSCRIPT="1_mt_scripts_configuration.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Sets up config file for all scripts in this directory to
# share with each other.

DATESTAMP=$(date +%Y%m%d.%H.%M.%S)
echo
echo "Building stack of search locations..."

# Save script location before building directory stack
# Most common location - directory tree includes this script
# readlink -f gives an absolute path, -n disables trailing newline
# dirname strips off filename (removes anything after last /)
# it will loop once and pull off the scripts directory, then accept.
SCRIPTPATH=$(dirname $(readlink -n -f $0))

# Filename to look for in MTROOT
INDICATOR="valid-mtroot"

# sentinel on stack
SENTINEL="$HOME/.xyzzy-mt-temp"
rmdir $SENTINEL &> /dev/null
mkdir $SENTINEL
pushd $SENTINEL >> /dev/null
SENTINEL=$(pwd)

# Push fallback location
pushd $HOME/multitouch/ >> /dev/null

# Push script location - most likely
pushd $SCRIPTPATH >> /dev/null

# accept paths passed in on command line
if [ -n "$1" ]; then	
	pushd $(readlink -n -f $1/multitouch/) >> /dev/null
	pushd $(readlink -n -f $1/) >> /dev/null
fi


# make sure we stacked something
if [ $(pwd) = $SENTINEL ]; then
	echo "Done before we started - nothing pushed? - probably a bug."
	dirs -v
	popd > /dev/null
	rmdir $SENTINEL
	exit 1
fi

# Begin loop to find a directory tree for the multitouch package.
echo
echo "Searching stacked locations for a suitable directory tree..."
until [ $(pwd) = $SENTINEL ]; do

	MTROOT="$(pwd)"
	# until we find our indicator or can't go up further, go up a level
	until [ -f "$MTROOT/$INDICATOR" -o $MTROOT = "$(dirname $MTROOT)" ]; do
		MTROOT=$(dirname $MTROOT)
	done

	if [ -f "$MTROOT/$INDICATOR" ]; then
		# we have found our directory - great!
		break
	else
		# If we haven't found the directory,
		# move on to the next directory on the stack.
		popd > /dev/null
	fi
done

# Did we run out of places to look?
if [ $(pwd) = $SENTINEL ]; then
	echo "Error: no valid location could be guessed.  Make sure there is "
	echo "a file called somedir/$INDICATOR where somedir is a"
	echo "directory dedicated to this multitouch software system,"
	echo "usually freshly extracted from a tarball."
fi

# clean up mess from sentinel no matter if we succeeded or not.
# cleanliness is next to godliness, or something like that.
until [ "$(pwd)" = $SENTINEL ]; do
	popd > /dev/null
done
popd > /dev/null
rmdir $SENTINEL

# If we failed for whatever reason, leave now.
if [ ! -f "$MTROOT/$INDICATOR" ]; then
	echo "Exiting unsuccessfully."
	exit 1
fi

# Now, if execution continues, we are assured that $MTROOT is correct.
echo
echo "Multi-touch root path found: $MTROOT"
echo "Writing configuration file into that tree..."

# Find out if our scripts are under our MTROOT...
EXTERNALWARNING="# Standard in-tree script configuration"
if [ "$MTROOT/scripts" != "$(readlink -f $SCRIPTPATH)" ]; then
	echo
	echo "NOTE: $MTROOT set as MTROOT, but script run from"
	echo "$SCRIPTPATH rather than $MTROOT/scripts (scripts outside of tree)"
	echo
	echo "Creating symlink to scripts in $MTROOT/scripts - run from there"
	echo "to access the configuration we just wrote."
	echo 
	echo "If you didn't mean to do this, don't understand this, or just want"
	echo "a regular, plain installation - delete these files, extract the"
	echo "originals from scratch in their own directory, and run the script"
	echo "from within there."
	echo
	echo "Ctrl-Cnow to cancel without modifying anything."
	read -p "Or, press enter to go ahead..."

	ln -s $SCRIPTPATH $MTROOT/scripts

	# warning to write to conf file
	EXTERNALWARNING="# NOTE!
# This config file was written from outside the tree.
# A symlink to the script directory was created,
# so even though the scripts are in $SCRIPTPATH
# be sure to run them from $MTROOT/scripts to keep the
# separate configs straight.
# (This is an advanced option - if you didn't mean to do
# this, just wipe it all out and try again.)

"
fi

# backup old config, if present
CONF=$MTROOT/z_config.inc
CONFBAK=$MTROOT/bak/z_config.inc.bak.pre$DATESTAMP
mv $CONF $CONFBAK &> /dev/null

# write config file
cat > $CONF <<heredoc
# Config built $DATESTAMP

# Auto-generated configuration file for Ryan Pavlik's
# multi-touch scripts

# To auto-generate a new version, run
# scripts/1_mt_scripts_configuration.sh
# Make sure that you have a directory dedicated to this 
# mt software and that there are all the scripts in a
# scripts/ directory.

$EXTERNALWARNING

# You can find links to the most recent info at
# http://www.snc.edu/computerscience/ from the
# CS460 Senior Projects 2009 link.  Persevere - it
# might be several links away.

###############
# Configuration
# Root for script data, etc
MTROOT="$MTROOT"

# Location the config script was run from:
SCRIPTPATH="$SCRIPTPATH"


# Configuration v5 - validity detection move to globals, changed chainload order.
# Generation script updated 2009-04-26 
# That's all for now!  Have fun!

heredoc

echo "Creating barebones directories needed by other scripts..."
mkdir $MTROOT/packages &>/dev/null
mkdir $MTROOT/logs &>/dev/null
mkdir $MTROOT/nuigroup &>/dev/null
mkdir $MTROOT/bak &>/dev/null
mkdir $MTROOT/downloads &>/dev/null
mkdir $MTROOT/othersoftware &>/dev/null

cat > $MTROOT/logs/$DATESTAMP.$THISSCRIPT.log <<heredoc
$DATESTAMP.$THISSCRIPT.log
$(uname -a)

Actions
-------
Started script
Backed up old config if applicable to $CONFBAK
Generated config specifying MTROOT="$MTROOT"
and SCRIPTPATH="$SCRIPTPATH"
Script terminated successfully
heredoc

echo "All done!"

echo
echo "Next step: You can now run software install scripts as desired."
read -p "Press enter or wait 10 seconds to leave $THISSCRIPT..." -t 10
echo

