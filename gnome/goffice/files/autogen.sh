#!/bin/sh
# Run this to generate all the initial makefiles, etc.

PKG_NAME="goffice"

REQUIRED_AUTOMAKE_VERSION=1.9.0
REQUIRED_LIBTOOL_VERSION=1.4.3

# We need intltool >= 0.27.2 to extract the UTF-8 chars from source code:
REQUIRED_INTLTOOL_VERSION=0.27.2

# We require Automake 1.7.2, which requires Autoconf 2.54.
# (It needs _AC_AM_CONFIG_HEADER_HOOK, for example.)
REQUIRED_AUTOCONF_VERSION=2.54

# This enforces the version for the machine where the tarball is built
# from CVS.  This requirement might be stronger than the one in configure.in.
#
# An example: we might require pkg-config binary >= 0.18, because it
# implements Libs.private.  But we might require macro PKG_PROG_PKG_CONFIG
# from pkg-config >= 0.29 because this macro is able to detect old versions
# of pkg-config conrrectly and reports a sane error message.
#
# In other words, the distribution tarball can be created only with 0.29 or
# later, but it can be then compiled on any host with pkg-config >= 0.18.
#
# We would then use REQUIRED_PKG_CONFIG_VERSION=0.29 here and
# PKG_PROG_PKG_CONFIG([0.18]) in configure.in.

USE_GNOME2_MACROS=1
USE_COMMON_DOC_BUILD=yes

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

(test -f $srcdir/configure.ac	\
  && test -d $srcdir/goffice	\
  && test -f $srcdir/goffice/goffice.h) || {
    echo -n "**Error**: Directory "\'$srcdir\'" does not look like the" 1>&2
    echo " top-level goffice directory" 1>&2
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
  echo "You need to install the gnome-common module and make" 1>&2
  echo "sure the gnome-autogen.sh script is in your \$PATH." 1>&2
  exit 1
fi

GNOME_DATADIR="$gnome_datadir"

. $gnome_autogen

if grep 'which gtkdoc-rebase >/dev/null &&' $srcdir/gtk-doc.make >/dev/null 2>&1 &&	\
   grep '[^-]installfiles=`echo $(srcdir)/html/*`;' $srcdir/gtk-doc.make >/dev/null 2>&1; then
    echo '----------------------------------------------------' 1>&2
    echo "Your gtk-doc has a dependency problem.  Upgrade." 1>&2
    echo "See http://bugzilla.gnome.org/show_bug.cgi?id=506506" 1>&2
    echo '----------------------------------------------------' 1>&2
    exit 1
fi
