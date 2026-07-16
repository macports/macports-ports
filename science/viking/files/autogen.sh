#!/bin/sh
# Run this to generate all the initial makefiles, etc.

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd "$srcdir"

INTLTOOLIZE=`command -v intltoolize`
if test -z $INTLTOOLIZE; then
        echo "*** No intltoolize found, please install the intltool package ***"
        exit 1
fi

GTK_DOC=`command -v gtkdocize`
if test -z $GTK_DOC; then
        echo "*** No gtkdocize found, please install the gtk-doc-tools package ***"
        exit 1
fi

AUTORECONF=`command -v autoreconf`
if test -z $AUTORECONF; then
        echo "*** No autoreconf found, please install it ***"
        exit 1
fi

if test -z `command -v autopoint`; then
        echo "*** No autopoint found, please install it ***"
        exit 1
fi

gtkdocize --copy || exit $?
autopoint --force || exit $?
AUTOPOINT='intltoolize --automake --copy' autoreconf --force --install --verbose || exit $?

cd "$olddir"
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
