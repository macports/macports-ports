#!/bin/sh
# Run this to generate all the initial makefiles, etc.

PKG_NAME="libgsf"

REQUIRED_AUTOMAKE_VERSION=1.8
# We require Automake 1.7.1, which requires Autoconf 2.54.
REQUIRED_AUTOCONF_VERSION=2.54

USE_GNOME2_MACROS=1

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

abs_srcdir=`cd $srcdir && pwd`
ACLOCAL_FLAGS="-I $abs_srcdir/m4 $ACLOCAL_FLAGS"

(test -f $srcdir/configure.ac \
  && test -d $srcdir/gsf \
  && test -f $srcdir/gsf/gsf.h) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level libgsf directory"
    exit 1
}

ifs_save="$IFS"; IFS=":"
for dir in $PATH ; do
  IFS="$ifs_save"
  test -z "$dir" && dir=.
  if test -f "$dir/gnome-autogen.sh" ; then
    gnome_autogen="$dir/gnome-autogen.sh"
    gnome_datadir=`echo $dir | sed -e 's,/bin$,/share,'`
    break
  fi
done

if test -z "$gnome_autogen" ; then
  echo "You need to install the gnome-common module and make"
  echo "sure the gnome-autogen.sh script is in your \$PATH."
  exit 1
fi

GNOME_DATADIR="$gnome_datadir"
. $gnome_autogen
