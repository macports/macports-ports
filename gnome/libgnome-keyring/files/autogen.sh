#!/bin/sh
# Run this to generate all the initial makefiles, etc.

PKG_NAME="libgnome-keyring"
USE_GNOME2_MACROS=1
REQUIRED_AUTOMAKE_VERSION=1.7

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

# Some boiler plate to get git setup as expected
#if test -d $srcdir/.git; then
#	if test -f $srcdir/.git/hooks/pre-commit.sample && \
#	   test ! -f $srcdir/.git/hooks/pre-commit; then
#		cp -pv $srcdir/.git/hooks/pre-commit.sample $srcdir/.git/hooks/pre-commit
#	fi
#fi

(test -f $srcdir/configure.ac && test -f $srcdir/library/gnome-keyring.h) || {
	echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
	echo " top-level $PKG_NAME directory"
	exit 1
}

which gnome-autogen.sh || {
	echo "You need to install gnome-common from the GNOME CVS"
	exit 1
}

. gnome-autogen.sh
