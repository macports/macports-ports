#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="totem-pl-parser"
REQUIRED_M4MACROS=introspection.m4

(test -f $srcdir/configure.ac) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

which gnome-autogen.sh || {
	echo "You need to install gnome-common from the GNOME SVN"
	exit 1
}

REQUIRED_PKG_CONFIG_VERSION=0.17.1 REQUIRED_AUTOMAKE_VERSION=1.9 USE_GNOME2_MACROS=1 . gnome-autogen.sh "$@"
