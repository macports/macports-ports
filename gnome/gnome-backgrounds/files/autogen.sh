#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="gnome-backgrounds"

(test -f $srcdir/configure.ac \
  && test -d $srcdir/backgrounds ) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

echo "Running glib-gettextize"
glib-gettextize --copy --force

echo "Running intltoolize"
intltoolize --copy --force --automake

which gnome-autogen.sh || {
    echo "You need to install gnome-common package"
    exit 1
}
USE_GNOME2_MACROS=1 . gnome-autogen.sh
