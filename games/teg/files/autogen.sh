#!/bin/sh
# Run this to generate all the initial makefiles, etc.
srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="Tenes Empanadas Graciela"

(test -f $srcdir/configure.in \
  && test -f $srcdir/ChangeLog \
  && test -d $srcdir/client) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

autoreconf --verbose --install
glib-gettextize --force
intltoolize --copy --force


REQUIRED_AUTOMAKE_VERSION=1.7

USE_GNOME2_MACROS=1 ACLOCAL_FLAGS="-I macros $ACLOCAL_FLAGS" . gnome-autogen.sh
