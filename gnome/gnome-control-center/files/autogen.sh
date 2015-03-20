#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="control-center"
ACLOCAL_FLAGS="-I libgd $ACLOCAL_FLAGS"

(test -f $srcdir/configure.ac \
  && test -f $srcdir/autogen.sh \
  && test -d $srcdir/shell) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

DIE=0

rm -f .using-gnome-libs-package

if ! which gnome-autogen.sh ; then
  echo "You need to install the gnome-common module and make"
  echo "sure the gnome-autogen.sh script is in your \$PATH."
  exit 1
fi

. gnome-autogen.sh
