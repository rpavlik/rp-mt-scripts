# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Globals - chainloaded by the config file.

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

