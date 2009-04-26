THISSCRIPT="handle_broken_conf.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# In case the configure file figures out that it's broken,
# it will figure out where this file is and call it, to
# replace the broken file with the scripted dummy file.

NOTVALID="$(cat err.tmp)"

if [ "$NOTVALID" = "broken" ]; then

cat <<heredoc
***********************************************************************
                               ERROR!                                  
You seem to have an invalid z_config.inc file in your rp-mt-scripts:
this is usually because you moved the directory without running
scripts/1_mt_scripts_configuration.sh to fix the config.

The script you were trying to run has been cancelled.  Your broken
configuration file will be moved aside and replaced by a dummy, which
will take you through the next steps.  It will be as if you had never
configured the system before.

Any software you had installed to this mt system is most likely intact,
and should run fine once this configuration problem is ironed out.
***********************************************************************

heredoc

else

if [ "$NOTVALID" = "missing" ]; then

cat <<heredoc
***********************************************************************
                               WARNING!                                  
You are trying to run one of the rp-mt-scripts without configuring your
multi-touch system.  The configuration is simple and painless, but it
does need to be done.

First, make sure you unzipped the tarball into its own directory, so
that you have 'somedir' dedicated to this multi-touch system (no other
things in it) which has a subdirectory 'scripts' with a bunch of files
that come with - so you'll have 'somedir/scripts/*.sh'. There should be
a 'configure' file in somedir, too. 

If you want just a standard setup, that script will tell you at the end
the next step to take.
***********************************************************************

The program you tried to run cannot be run without being configured.
heredoc

else

echo "Some un-recognized error with conf - please reconfigure."

fi
fi


CONFDIR=$1

[ -f "$CONFDIR/configure" ] && CONFIG="$CONFDIR/configure"
[ -f "$CONFDIR/../configure" ] && CONFIG="$CONFDIR/../configure"
[ -f "$CONFDIR/rp-mt-scripts/configure" ] && CONFIG="$CONFDIR/rp-mt-scripts/configure"

[ "$CONFDIR" = "" ] && echo "rp-mt-scripts never configured, can't find configure script, bailing.  Unzip a fresh install." && exit

exec bash $CONFIG
exit 1
