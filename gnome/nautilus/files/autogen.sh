#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="nautilus"

(test -f $srcdir/configure.ac \
  && test -f $srcdir/README \
  && test -d $srcdir/libnautilus-private) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

git submodule update --init --recursive

which gnome-autogen.sh || {
    echo "gnome-autogen.sh not found, you need to install gnome-common"
    exit 1
}
REQUIRED_AUTOMAKE_VERSION=1.9 . gnome-autogen.sh
