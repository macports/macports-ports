#!/bin/sh
# Run this to generate all the initial makefiles, etc.

REQUIRED_AUTOMAKE_VERSION=1.9

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="Genius"

(test -f $srcdir/configure.ac \
  && test -d $srcdir/src \
  && test -f $srcdir/src/calc.h) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level Genius directory"
    exit 1
}

which gnome-autogen.sh || {
    echo "Missing gnome-autogen.sh"
    echo "You need to install gnome-common from the GNOME git,"
    echo "or possibly the \"gnome-common\" distribution package"
    exit 1
}
USE_GNOME2_MACROS=1 . gnome-autogen.sh
