#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="GNOME Font Viewer"

(test -f $srcdir/configure.ac \
  && test -f $srcdir/src/font-view.c) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level font-viewer directory"
    exit 1
}

which gnome-autogen.sh || {
    echo "You need to install gnome-common package"
    exit 1
}

USE_GNOME2_MACROS=1 USE_COMMON_DOC_BUILD=yes . gnome-autogen.sh
