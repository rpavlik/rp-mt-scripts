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

is_installed ()
{
	if [ "$APT" != "" ]; then
		echo $(dpkg -s $1 | grep -o "install ok")
	else
		echo
	fi
}

package_install ()
{
	if [ "$APT" != "" ]; then
		# OK, we can try to install somehow
		if [ "$UBUNTU" != "yes" ]; then
			echo "NOTE: You're not on Ubuntu - make sure the equivalent of these are installed:"
			echo "$@"
			echo "Trying to install them..."
		fi
		$APT $@
	else
		echo "ERROR: You're not using a Debian/Ubuntu derivative - install these yourself:"
		echo "$@"
	fi
}


# Global detection stuff that runs before every script

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

# Attempt to find package install tool in Ubuntu, Debian, and similar
APT=""
if [ "$(which aptitude)" != "" ]; then
	APT="sudo aptitude -y -q --with-recommends install"
else
	if [ "$(which apt-get)" != "" ]; then
		APT="sudo apt-get -y -qq install"
	fi
fi

# For the sake of warnings, find out if we're on ubuntu.
UBUNTU=""
if [ "$(lsb_release -i -s)" = "Ubuntu" ]; then
	UBUNTU=yes
	UBUNTUVER="$(lsb_release -r -s)"
	DISTCODENAME="$(lsb_release -c -s)"
	log_append "Running on $(lsb_release -d -s)"
else
	if [ "$(lsb_release -i -s)" = "Debian" ]; then
		UBUNTU=Debian
		DISTCODENAME="$(lsb_release -c -s)"
		log_append "Debian, not Ubuntu! Running on $(lsb_release -d -s)"
	else
		log_append "Not running on Ubuntu or Debian! Running on $(lsb_release -d -s)"
	fi
fi

# Make sure our return value is zero
echo

