#!/bin/sh
#Authors: Dodji Seketeli & Gaël Chamoulaud.

# Run this to generate all the initial makefiles, etc. srcdir=`dirname $0`
test -z "$srcdir" && srcdir=. 

PKG_NAME="mlview" 

(test -f $srcdir/configure.in \
  && test -f $srcdir/ChangeLog \
  && test -d $srcdir/src) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
} 

which gnome-autogen.sh || {
    echo "You need to install gnome-common from the GNOME CVS"
    exit 1
}

if test x$@ = x -a x$MLVIEW_DEVEL != x; then
    args="--enable-verbose=yes --enable-custom-cell-renderer=yes --enable-gtk-file-chooser=yes"
else
    args="$@"
fi

REQUIRED_AUTOMAKE_VERSION=1.7.2

USE_GNOME2_MACROS=1 . gnome-autogen.sh $args
