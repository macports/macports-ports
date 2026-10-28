#!/bin/sh
# Run this to generate all the initial makefiles, etc.

PKG_NAME="gtkhtml"
REQUIRED_AUTOCONF_VERSION=2.58
REQUIRED_AUTOMAKE_VERSION=1.9
REQUIRED_LIBTOOL_VERSION=2.2
REQUIRED_INTLTOOL_VERSION=0.36.3

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

(test -f $srcdir/configure.ac \
  && test -d $srcdir/gtkhtml \
  && test -f $srcdir/gtkhtml/gtkhtml.h) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level gtkhtml directory"
    exit 1
}

gnome_autogen=
gnome_datadir=

ifs_save="$IFS"; IFS=":"
for dir in $PATH ; do
  test -z "$dir" && dir=.
  if test -f $dir/gnome-autogen.sh ; then
    gnome_autogen="$dir/gnome-autogen.sh"
    gnome_datadir=`echo $dir | sed -e 's,/bin$,/share,'`
    break
  fi
done
IFS="$ifs_save"

if test -z "$gnome_autogen" ; then
  echo "You need to install the gnome-common module and make"
  echo "sure the gnome-autogen.sh script is in your \$PATH."
  exit 1
fi

GNOME_DATADIR="$gnome_datadir" USE_GNOME2_MACROS=1 . $gnome_autogen

