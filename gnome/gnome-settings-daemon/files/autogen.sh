#!/bin/sh
# Run this to generate all the initial makefiles, etc.

REQUIRED_AUTOMAKE_VERSION=1.5
USE_GNOME2_MACROS=1

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="gnome-settings-daemon"

(test -f $srcdir/configure.ac \
  && test -d $srcdir/gnome-settings-daemon \
  && test -f $srcdir/gnome-settings-daemon/gnome-settings-manager.h) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level gnome-settings-daemon directory"
    exit 1
}

which gnome-autogen.sh || {
    echo "You need to install gnome-common from the GNOME SVN"
    exit 1
}

# Fetch submodules if needed
# if test ! -f plugins/media-keys/gvc/Makefile.am; then
#   echo "+ Setting up submodules"
#   git submodule init
# fi
# git submodule update

. gnome-autogen.sh
