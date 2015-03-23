#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

DIE=0

(test -f $srcdir/configure.ac) || {
    echo -n "**Error**: Directory $srcdir does not look like the"
    echo " top-level package directory"
    exit 1
}

olddir=`pwd`
cd "$srcdir"

touch ChangeLog

(autoconf --version) < /dev/null > /dev/null 2>&1 || {
  echo
  echo "**Error**: You must have autoconf installed."
  echo "Download the appropriate package for your distribution,"
  echo "or get the source tarball at ftp://ftp.gnu.org/pub/gnu/"
  DIE=1
}

(grep "^AM_PROG_LIBTOOL" configure.ac >/dev/null) && {
  (glibtoolize --version) < /dev/null > /dev/null 2>&1 || {
    echo
    echo "**Error**: You must have libtool installed."
    echo "You can get it from: ftp://ftp.gnu.org/pub/gnu/"
    DIE=1
  }
}

(gtkdocize --flavour no-tmpl) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have gtk-doc installed to compile $PROJECT."
	echo "Install the appropriate package for your distribution,"
	echo "or get the source tarball at http://ftp.gnome.org/pub/GNOME/sources/gtk-doc/"
	DIE=1
}

(automake --version) < /dev/null > /dev/null 2>&1 || {
  echo
  echo "**Error**: You must have automake installed."
  echo "You can get it from: ftp://ftp.gnu.org/pub/gnu/"
  DIE=1
  NO_AUTOMAKE=yes
}


# if no automake, don't bother testing for aclocal
test -n "$NO_AUTOMAKE" || (aclocal --version) < /dev/null > /dev/null 2>&1 || {
  echo
  echo "**Error**: Missing aclocal.  The version of automake"
  echo "installed doesn't appear recent enough."
  echo "You can get automake from ftp://ftp.gnu.org/pub/gnu/"
  DIE=1
}


# if no automake, don't bother testing for autoreconf
test -n "$NO_AUTOMAKE" || (autoreconf --version) < /dev/null > /dev/null 2>&1 || {
  echo
  echo "**Error**: You must have autoreconf installed."
  echo "You can get autoreconf from ..."
  DIE=1
}


if test "$DIE" -eq 1; then
  exit 1
fi

if test -z "$*"; then
  echo "**Warning**: I am going to run configure with no arguments."
  echo "If you wish to pass any to it, please specify them on the"
  echo $0 " command line."
  echo
fi

case $CC in
xlc )
  am_opt=--include-deps;;
esac

      aclocalinclude="$ACLOCAL_FLAGS"

      echo "Running autoreconf on test/mocklibc ..."
      (cd "test/mocklibc"; autoreconf --install)

      if grep "^AM_PROG_LIBTOOL" configure.ac >/dev/null; then
	if test -z "$NO_LIBTOOLIZE" ; then 
	  echo "Running glibtoolize..."
	  glibtoolize --force --copy
	fi
      fi
      echo "Running aclocal $aclocalinclude ..."
      aclocal $aclocalinclude
      if grep "^AC_CONFIG_HEADERS" configure.ac >/dev/null; then
	echo "Running autoheader..."
	autoheader
      fi
      echo "Running automake --gnu -Wno-portability $am_opt ..."
      automake --add-missing --gnu -Wno-portability $am_opt
      echo "Running autoconf ..."
      autoconf

intltoolize --copy --force --automake                  || exit 1

cd "$olddir"

conf_flags=""

if test x$NOCONFIGURE = x; then
  echo "Running $srcdir/configure $conf_flags $@ ..."
  $srcdir/configure $conf_flags "$@" \
  && echo "Now type make to compile." || exit 1
else
  echo "Skipping configure process."
fi
