#!/bin/sh
# Run this to generate all the initial makefiles, etc.

PKG_NAME="Goffice"

test -n "$srcdir" || srcdir=$(dirname "$0")
test -n "$srcdir" || srcdir=.

olddir=$(pwd)

(test -f $srcdir/configure.ac	\
  && test -d $srcdir/goffice	\
  && test -f $srcdir/goffice/goffice.h) || {
    echo -n "**Error**: Directory "\'$srcdir\'" does not look like the" 1>&2
    echo " top-level goffice directory" 1>&2
    exit 1
}

cd $srcdir
aclocal --install || exit 1
glib-gettextize --force --copy || exit 1
gtkdocize --copy || exit 1
intltoolize --force --copy --automake || exit 1
autoreconf --verbose --force --install || exit 1
cd $olddir

if [ "$NOCONFIGURE" = "" ]; then
        $srcdir/configure "$@" || exit 1

        if [ "$1" = "--help" ]; then exit 0 else
                echo "Now type 'make' to compile $PKG_NAME" || exit 1
        fi
else
        echo "Skipping configure process."
fi
