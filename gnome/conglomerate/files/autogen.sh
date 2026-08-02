#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="Conglomerate"

(test -f $srcdir/configure.in \
  && test -f $srcdir/src/main.c) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}
which gnome-autogen.sh || {
        echo "You need to install the 'gnome-common' package"
        echo "or get it from the GNOME CVS."
        exit 1
}

# Ensure that we always configure with --enable-werror when building from CVS:
#REQUIRED_AUTOMAKE_VERSION="1.7" \
#USE_GNOME2_MACROS=1 . gnome-autogen.sh "$@" --enable-werror
USE_GNOME2_MACROS=1 . gnome-autogen.sh "$@"

# last line of autogen.sh
