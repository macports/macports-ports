#!/bin/sh

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd "$srcdir"

# run gtkdocize
gtkdocize || exit 1

intltoolize --force --copy --automake || exit 1

# gnome-autogen.sh runs configure, so do likewise.
autoreconf -vif

cd "$olddir"

test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"

