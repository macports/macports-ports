#! /bin/sh

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd "$srcdir"

AUTORECONF=`which autoreconf`
if test -z $AUTORECONF; then
        echo "*** No autoreconf found, please install it ***"
        exit 1
fi
INTLTOOLIZE=`which intltoolize`
if test -z $INTLTOOLIZE; then
        echo "*** No intltoolize found, please install the intltool package ***"
        exit 1
fi

intltoolize --force --copy --automake || exit $?
autoreconf --force --install --verbose || exit $?

cd "$olddir"
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
