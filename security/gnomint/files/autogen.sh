#!/bin/bash
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="gnoMint"
AUTOCONF=autoconf
REQUIRED_AUTOCONF_VERSION=2.59
AUTOMAKE=automake-1.9
REQUIRED_AUTOMAKE_VERSION=1.9

(test -f $srcdir/configure.in \
  && test -d $srcdir/src \
  && test -f $srcdir/src/main.c) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level gnoMint directory"
    exit 1
}

gnome_autogen=`which gnome-autogen.sh`
test -z "$gnome_autogen"

USE_GNOME2_MACROS=1 . $gnome_autogen
