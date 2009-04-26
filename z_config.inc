# DUMMY

# Dummy configuration file for Ryan Pavlik's
# multi-touch scripts

# To auto-generate a new version, run
# scripts/1_mt_scripts_configuration.sh
# Make sure that you have a directory dedicated to this 
# mt software and that there are all the scripts in a
# scripts/ directory.

# You can find links to the most recent info at
# http://www.snc.edu/computerscience/ from the
# CS460 Senior Projects 2009 link.  Persevere - it
# might be several links away.


cat <<heredoc
***********************************************************************
                               ERROR!                                  
You are trying to run one of the rp-mt-scripts without configuring your
multi-touch system.  The configuration is simple and painless, but does 
need to be done.

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

CONFTRY="configure ../configure rp-mt-scripts/configure"
CONFPATH="no"
for CONF in $CONFTRY;do
	echo $CONF
	if [ -f '$CONF' ]; then
		CONFPATH="$(readlink -f -n $CONF)"
		CONFFILE=$CONF
		break
	fi
done

if [ "$CONFPATH" != "no" ]; then
	echo "I can start the ./configure script for you - I found it at:"
	echo $CONFPATH
	echo "Type 'yes', no quotes, and press enter to run configure, anything else cancels."

	read -p "Would you like me to run configure for you? " answer
	if [ "$ANSWER" = "yes" ]; then
		echo "Sure thing, here we go!"
		echo
		cd $(dirname $CONFPATH)
		./configure
	fi
else
	cat <<-heredoc
		I can't find the configure script - make sure that you unzipped the
		package correctly as explaind above.  Then, run ./configure from in
		its directory - you must change to its directory first!

		Exiting to let you check your setup and do that.
	heredoc
fi

exit 1
