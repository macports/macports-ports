#!/bin/sh
# Run this to generate all the initial makefiles, etc.

# Modified according to the new way of calling autogen.sh -- SnM 

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="GHex"

(test -f $srcdir/configure.ac \
  && test -f $srcdir/src/ghex-window.h) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

# Check for gnome-autogen.sh existence
which gnome-autogen.sh || {
    echo "You need to install gnome-common from GNOME Git (or from"
    echo "your OS vendor's package manager)."
    exit 1
}

. gnome-autogen.sh
