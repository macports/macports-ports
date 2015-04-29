#!/bin/sh
# Run this to generate all the initial makefiles, etc.

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd "$srcdir"

INTLTOOLIZE=`which intltoolize`
if test -z $INTLTOOLIZE; then
        echo "*** No intltoolize found, please install the intltool package ***"
        exit 1
fi

GTK_DOC=`which gtkdocize`
if test -z $GTK_DOC; then
        echo "*** No gtkdocize found, please install the gtk-doc-tools package ***"
        exit 1
fi

GNOME_DOC=`which gnome-doc-prepare`
if test -z $GNOME_DOC; then
        echo "*** No gnome-doc-prepare found, please install the gnome-doc-utils package ***"
        exit 1
fi

AUTORECONF=`which autoreconf`
if test -z $AUTORECONF; then
        echo "*** No autoreconf found, please install it ***"
        exit 1
fi

if test -z `which autopoint`; then
        echo "*** No autopoint found, please install it ***"
        exit 1
fi

gnome-doc-prepare --automake --copy --force || exit $?
gtkdocize --copy || exit $?
autopoint --force || exit $?
AUTOPOINT='intltoolize --automake --copy --force' autoreconf --force --install --verbose || exit $?

cd "$olddir"
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"

