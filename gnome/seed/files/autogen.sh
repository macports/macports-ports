#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="seed"

(test -f $srcdir/src/main.c) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

which gnome-autogen.sh || {
    echo "You need to install gnome-common from GNOME SVN and make"
    echo "sure the gnome-autogen.sh script is in your \$PATH."
    exit 1
}

REQUIRED_AUTOMAKE_VERSION=1.9 
REQUIRED_INTLTOOL_VERSION=0.40.4
. gnome-autogen.sh
