#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="libgnomeprint"

(test -f $srcdir/configure.in \
  && test -f $srcdir/autogen.sh \
  && test -d $srcdir/libgnomeprint) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

DIE=0

rm -f .using-gnome-libs-package

# This is a bit complicated here since we can't use gnome-config yet.
# It'll be easier after switching to pkg-config since we can then
# use pkg-config to find the gnome-autogen.sh script.

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

REQUIRED_AUTOMAKE_VERSION=1.7.2 NOCONFIGURE="dont" GNOME_DATADIR="$gnome_datadir" USE_GNOME2_MACROS=1 . $gnome_autogen

## Added experimentally to see if this fixes the tinderbox
if test -z "$AUTOGEN_SUBDIR_MODE"; then
   $srcdir/configure "$@"
   echo 
   echo "Now type 'make' to compile $PKG_NAME."
fi
