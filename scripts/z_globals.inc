# Ryan Pavlik <ryan.pavlik@snc.edu> 2009

# Globals - chainloaded by the config file.

DATESTAMP=$(date +%Y%m%d.%H.%M.%S)
LOGFILE=$MTROOT/scriptlogs/$DATESTAMP.$THISSCRIPT.log

cat >$LOGFILE <<heredoc
$DATESTAMP.$THISSCRIPT.log
$(uname -a)

Actions
-------
Started script
heredoc

function log_append()
{
	echo $1 >> $LOGFILE
}

