#!/bin/bash
#
# $Id: autogen.sh,v 1.11 2008-05-06 14:44:52 dleidert Exp $

set -e

## all initial declarations, overwrite them using e.g. 'ACLOCAL=aclocal-1.8 AUTOMAKE=automake-1.8 ./autogen.sh'
ACLOCAL=${ACLOCAL:-aclocal}
AUTOCONF=${AUTOCONF:-autoconf}
AUTOHEADER=${AUTOHEADER:-autoheader}
AUTOMAKE=${AUTOMAKE:-automake}
GETTEXTIZE=${GETTEXTIZE:-gettextize}
INTLTOOLIZE=${INTLTOOLIZE:-intltoolize}
LIBTOOLIZE=${LIBTOOLIZE:-glibtoolize}

## check, if all binaries exist and fail with error 1 if not
if [ -z `which $ACLOCAL` ] ; then echo "Error. ACLOCAL=$ACLOCAL not found." >&2 && exit 1 ; fi
if [ -z `which $AUTOCONF` ] ; then echo "Error. AUTOCONF=$AUTOCONF not found." >&2 && exit 1 ; fi
if [ -z `which $AUTOHEADER` ] ; then echo "Error. AUTOHEADER=$AUTOHEADER not found." >&2 && exit 1 ; fi
if [ -z `which $AUTOMAKE` ] ; then echo "Error. AUTOMAKE=$AUTOMAKE not found." >&2 && exit 1 ; fi
if [ -z `which $GETTEXTIZE` ] ; then echo "Error. GETTEXTIZE=$GETTEXTIZE not found." >&2 && exit 1 ; fi
if [ -z `which $INTLTOOLIZE` ] ; then echo "Error. INTLTOOLIZE=$INTLTOOLIZE not found." >&2 && exit 1 ; fi
if [ -z `which $LIBTOOLIZE` ] ; then echo "Error. LIBTOOLIZE=$LIBTOOLIZE not found." >&2 && exit 1 ; fi

## find where automake is installed and get the version
AUTOMAKE_PATH=${AUTOMAKE_PATH:-`which $AUTOMAKE | sed 's|\/bin\/automake.*||'`}
AUTOMAKE_VERSION=`$AUTOMAKE --version | grep automake | awk '{print $4}' | awk -F. '{print $1"."$2}'`

## find gettext version. Use GETTEXTIZE since it is already initialized
GETTEXT_VERSION=`$GETTEXTIZE --version | grep gettextize | awk '{print $4}' | awk -F. '{print $1"."$2}'`

## automake files we need to have inside our source
if [[ $AUTOMAKE_VERSION = "1.7" || $GETTEXT_VERSION < "0.15" ]] ; then
        AUTOMAKE_FILES="missing mkinstalldirs install-sh"
else
        AUTOMAKE_FILES="missing install-sh"
fi

## the directories which will contain the $GETTEXT_FILES
GETTEXT_PO_DIRS="
src/plugin_about/po
src/plugin_charmap/po
src/plugin_entities/po
src/plugin_htmlbar/po
src/plugin_infbrowser/po
src/plugin_snippets/po
src/plugin_xmltools/po
src/plugin_zencoding/po
"

## the gettext files we need to copy to $GETTEXT_PO_DIRS
GETTEXT_FILES="
Makefile.in.in
boldquot.sed
en@boldquot.header
en@quot.header
insert-header.sin
quot.sed
remove-potcdate.sin
Rules-quot
"

## the prefix where we expect share/gettext/po/$GETTEXT_FILES files
GETTEXT_LOCATION_LIST="
`which $GETTEXTIZE | sed 's|\/bin\/gettextize|\/share\/gettext\/po|'`
`echo $PATH | tr ':' '\n' | sed 's|bin|share|;s|$|\/gettext\/po|g'`
/usr/share/gettext/po
/usr/local/share/gettext/po
"

## use $GETTEXT_LOCATION to add a custom gettext location prefix
GETTEXT_LOCATION=${GETTEXT_LOCATION:-$GETTEXT_LOCATION_LIST}

## check if $GETTEXT_LOCATION contains the files we need and set $GETTEXT_DIR
for dir in $GETTEXT_LOCATION  ; do
	if [ -f $dir/Makefile.in.in ] ; then
		GETTEXT_DIR=$dir
		break
	fi
done

## if $GETTEXT_DIR is still undefined, fail with error 1
if [ -z $GETTEXT_DIR ] ; then
	echo "Error. GETTEXT_LOCATION=$GETTEXT_LOCATION_LIST does not exist." >&2
	exit 1
fi

## our help output - if autogen.sh was called with -h|--help or unkbown option
autogen_help() {
	echo
	echo "autogen.sh usage:"
	echo
	echo "  Produces all files necessary to build the bluefish project files."
	echo "  The files are linked by default, if you run ./autogen.sh without an option."
	echo
	echo "    -v        Be more verbose about every step (debugging)."
	echo "    -f FILE   Output everything to FILE (debugging). Useful for debug output."
	echo "    -c        Copy files instead to link them."
	echo "    -h        Print this message."
	echo
	echo "  You can overwrite the automatically determined location of aclocal (>= 1.8),"
	echo "  automake (>= 1.8), autoheader, autoconf, libtoolize, intltoolize and"
	echo "  gettextize using:"
	echo
	echo "    ACLOCAL=/foo/bin/aclocal-1.9 AUTOMAKE=automake-1.9 ./autogen.sh"
	echo
}

## copy $GETTEXT_FILES from $GETTEXT_DIR into $GETTEXT_PO_DIRS
## this will probably become obsolete with gettext 0.16.2, which adds the
## necessary functionality to gettextize - we should prefer this way then
prepare_gettext() {
	for dir in $GETTEXT_PO_DIRS ; do
		if [ -d $dir ] ; then
			for file in $GETTEXT_FILES ; do
				if [ -n "$VERBOSE" ]; then
					echo "DEBUG: $COPYACTION -f $GETTEXT_DIR/$file `pwd`/$dir" >&2
				fi
				$COPYACTION -f $GETTEXT_DIR/$file `pwd`/$dir
			done
		else
			echo "ERROR: $dir does not exist!"
			break
		fi
	done
}

## check if $AUTOMAKE_FILES were copied to our source
## link/copy them if not - necessary for e.g. gettext, which seems to always need mkinstalldirs
autogen_if_missing() {
	for file in $AUTOMAKE_FILES ; do
		if [ ! -e "$file" ] ; then
			if [ -n "$VERBOSE" ]; then
				echo "DEBUG: $COPYACTION -f $AUTOMAKE_PATH/share/automake-$AUTOMAKE_VERSION/$file ." >&2
			fi
			$COPYACTION -f $AUTOMAKE_PATH/share/automake-$AUTOMAKE_VERSION/$file .
		fi
	done
}

## link/copy the necessary files to our source to prepare for a build
autogen() {
	$LIBTOOLIZE $DEBUG -f $COPYOPTION
	$INTLTOOLIZE $DEBUG -f $COPYOPTION
	prepare_gettext
	$ACLOCAL $ACLOCAL_OPT --force $VERBOSE
	$AUTOHEADER -f $DEBUG $VERBOSE
	$AUTOMAKE --gnu -a $VERBOSE $COPYOPTION
	autogen_if_missing
	$AUTOCONF $DEBUG $VERBOSE
}

## the main function
COPYACTION="ln -s"
while getopts "chvf:" options; do
	case "$options" in
		h)
			autogen_help
			exit 0
		;;
		c)
			COPYACTION="cp"
			COPYOPTION="-c"
		;;
		f)
			OUTPUTFILE=$OPTARG
		;;
		v)
			DEBUG="--debug"
			VERBOSE="--verbose"
			set -x
		;;
	esac
done

if [ -n "$OUTPUTFILE" ]; then
	exec &>$OUTPUTFILE
fi
autogen

## ready to rumble
echo "Run ./configure with the appropriate options, then make and enjoy."

exit 0

