#!/bin/sh
#
# Document  $Id: autogen.sh 58 2006-12-30 15:40:20Z dleidert $
# Summary   Auto-generate the package source.
#
# Copyright (C) 2004-2006 Egon Willighagen.
# Copyright (C) 2004-2006 Daniel Leidert <daniel.leidert@wgdd.de>.
#
# This file is free software. The copyright owner gives unlimited
# permission to copy, distribute and modify it.

set -e

## all initial declarations, overwrite them using e.g. 'ACLOCAL=aclocal-1.7 AUTOMAKE=automake-1.7 ./autogen.sh'
ACLOCAL=${ACLOCAL:-aclocal}
AUTOCONF=${AUTOCONF:-autoconf}
AUTOMAKE=${AUTOMAKE:-automake}
INTLTOOLIZE=${INTLTOOLIZE:-intltoolize}

## check, if all binaries exist and fail with error 1 if not
if [ -z `which $ACLOCAL` ] ; then echo "Error. ACLOCAL=$ACLOCAL not found." >&2 && exit 1 ; fi
if [ -z `which $AUTOCONF` ] ; then echo "Error. AUTOCONF=$AUTOCONF not found." >&2 && exit 1 ; fi
if [ -z `which $AUTOMAKE` ] ; then echo "Error. AUTOMAKE=$AUTOMAKE not found." >&2 && exit 1 ; fi
if [ -z `which $INTLTOOLIZE` ] ; then echo "Error. INTLTOOLIZE=$INTLTOOLIZE not found." >&2 && exit 1 ; fi

## find where automake is installed and get the version
AUTOMAKE_PATH=${AUTOMAKE_PATH:-`which $AUTOMAKE | sed 's|\/bin\/automake.*||'`}
AUTOMAKE_VERSION=`$AUTOMAKE --version | grep automake | awk '{print $4}' | awk -F. '{print $1"."$2}'`

## automake files we need to have inside our source
if [ $AUTOMAKE_VERSION = "1.7" ] ; then
        AUTOMAKE_FILES="missing mkinstalldirs install-sh"
else
        AUTOMAKE_FILES="missing install-sh"
fi

## our help output - if autogen.sh was called with -h|--help or unknown option
autogen_help() {
	echo
	echo "autogen.sh usage:"
	echo
	echo "  Produces all files necessary to build the chemical-mime-data project files."
	echo "  The files are linked by default, if you run ./autogen.sh without an option."
	echo
	echo "    -c, --copy      Copy files instead to link them."
	echo "    -h, --help      Print this message."
	echo
	echo "  You can overwrite the automatically determined location of aclocal, automake,"
	echo "  autoconf and intltoolize using:"
	echo
	echo "    ACLOCAL=/foo/bin/aclocal-1.8 AUTOMAKE=automake-1.8 ./autogen.sh"
	echo
}

## check if $AUTOMAKE_FILES were copied to our source
## link/copy them if not - necessary for e.g. gettext, which seems to always need mkinstalldirs
autogen_if_missing() {
	case "$1" in
		copy)
			command="cp"
		;;
		link)
			command="ln -s"
		;;
		*)
			echo "Error. autogen_if_missing() was called with unknown parameter $1." >&2
		;;
	esac
	
	for file in $AUTOMAKE_FILES ; do
		if [ ! -e "$file" ] ; then
			$command -f $AUTOMAKE_PATH/share/automake-$AUTOMAKE_VERSION/$file .
		fi
	done
}

## link/copy the necessary files to our source to prepare for a build
autogen() {
	case "$1" in
		copy)
			copyoption="-c"
		;;
		link)
		;;
		*)
			echo "Error. autogen() was called with unknown parameter $1." >&2
		;;
	esac
	$INTLTOOLIZE -f $copyoption
	$ACLOCAL
	$AUTOMAKE --gnu -a $copyoption
	autogen_if_missing $1
	$AUTOCONF
}

## the main function
case "$1" in
	-h | --help)
		autogen_help
		exit 0
	;;
	-c | --copy)
		autogen copy
	;;
	*)
		autogen link
	;;
esac

## ready to rumble
echo "Run ./configure with the appropriate options, then make and enjoy."

exit 0

