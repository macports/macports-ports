#!/bin/sh
# Run this to generate all the initial makefiles, etc.

PKG_NAME="gnome-keyring"
USE_GNOME2_MACROS=1
REQUIRED_AUTOMAKE_VERSION=1.7

olddir=`pwd`
srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

(test -f $srcdir/configure.ac \
  && test -f $srcdir/daemon/gkd-main.c) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

which gnome-autogen.sh || {
    echo "You need to install gnome-common from the GNOME Git"
    exit 1
}

. gnome-autogen.sh

# Put a redirect makefile here
if [ ! -f $srcdir/Makefile ]; then
    cat $srcdir/build/Makefile.redirect > $srcdir/Makefile
    printf "\nREDIRECT = %s\n" "$(realpath $olddir)" >> $srcdir/Makefile
fi
