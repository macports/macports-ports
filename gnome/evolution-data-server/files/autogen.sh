#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="evolution-data-server"
REQUIRED_AUTOCONF_VERSION=2.58
REQUIRED_AUTOMAKE_VERSION=1.10
REQUIRED_LIBTOOL_VERSION=2.2
REQUIRED_INTLTOOL_VERSION=0.35.5

(test -f $srcdir/configure.ac \
  && test -f $srcdir/ChangeLog \
  && test -d $srcdir/calendar) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

which gnome-autogen.sh || {
    echo "You need to install gnome-common from the GNOME CVS"
    exit 1
}

USE_GNOME2_MACROS=1 . gnome-autogen.sh
