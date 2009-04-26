THISSCRIPT="handle_broken_conf.sh"
# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# In case the configure file figures out that it's broken,
# it will figure out where this file is and call it, to
# replace the broken file with the scripted dummy file.


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

CONFDIR=$1

echo "Broken configure script indicates it was in $CONFDIR"
mv "$CONFDIR/z_config.inc $CONFDIR/$(date +%Y%m%d.%H.%M.%S).z_config.inc.broken"
cat "$CONFDIR/z_config.inc" <<"heredoc"
# DUMMY

[ -f dummy_z_config.inc ] && DUMMY="dummy_z_config.inc"
[ -f "../dummy_z_config.inc" ] && DUMMY="../dummy_z_config.inc"
[ -f "rp-mt-scripts/dummy_z_config.inc" ] && DUMMY="rp-mt-scripts/dummy_z_config.inc"

[ "$DUMMY" = "" ] && echo "rp-mt-scripts never configured, can't find dummy, bailing.  Unzip a fresh install." && exit

source $DUMMY
heredoc

source "$CONFDIR/z_config.inc"

exit 1
