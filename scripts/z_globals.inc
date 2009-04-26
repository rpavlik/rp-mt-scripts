# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Globals

source z_config.inc  &> /dev/null || source ../z_config.inc &> /dev/null
RV=$?

if [ $RV -ne 0 ]; then
	# Could not load the config
	# we need to do something about that.
	NOTVALID="missing"
else
	# config loaded, checking validity.

	if [ ! -f "$MTROOT/valid-mtroot" ]; then
		# MTROOT not valid, we need to do something about that.
		NOTVALID="broken"
	fi

fi

if [ "$NOTVALID" != "" ]; then
	# For some reason we must not continue.
	# Call in to fix the problem.

	# we know that $0 contains the path to the script that called us,
	# so z_config.inc must be in the parent directory,
	# unless $0 is "configure" or "install.sh" in which case it's in the same directory

	INCLUDERPATH="$(readlink -f -n $0)"
	INCLUDERDIR="$(dirname $INCLUDERPATH)"
	ISCONFIGURE="$(echo $0 | grep 'configure$')"
	ISINSTALLSH="$(echo $0 | grep 'install.sh$')"
	if [ "$ISCONFIGURE$ISINSTALLSH" = "" ]; then
		CONFDIR="$(dirname $INCLUDERDIR)"
	else
		CONFDIR="$INCLUDERDIR"
	fi

	echo "$NOTVALID" > ../err.tmp
	# Now, we must bail into a "confbroken" handler.
	cd "$CONFDIR"
	exec bash handle_broken_conf.sh "$CONFDIR"

fi



DATESTAMP=$(date +%Y%m%d.%H.%M.%S)
LOGFILE=$MTROOT/logs/$DATESTAMP.$THISSCRIPT.log
REALLOGFILE=$LOGFILE
if [ "$NOLOGGING" = "NOLOGGING" ]; then
	LOGFILE=/dev/null
fi

cat >$LOGFILE <<heredoc
$DATESTAMP.$THISSCRIPT.log
$(uname -a)

Actions
-------
Started script
heredoc

log_append ()
{
	echo $1 >> $LOGFILE
}

log_append_override ()
{
	echo $1 >> $REALLOGFILE
}

log_append_dated ()
{
	echo "$1 ($(date +%Y%m%d.%H.%M.%S))" >> $LOGFILE
}

log_end ()
{
	echo "Script ended at $(date +%Y%m%d.%H.%M.%S)" >> $LOGFILE
}

pause_exit ()
{
	echo
	read -p "Press enter or wait 10 seconds to leave $0..." -t 10
	echo
}

