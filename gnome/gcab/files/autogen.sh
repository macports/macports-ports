#!/bin/sh

set -e # exit on errors

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.
mkdir -p "$srcdir/m4"

gtkdocize
intltoolize -f
autoreconf -v --force --install

if [ -z "$NOCONFIGURE" ]; then
    "$srcdir"/configure "$@"
fi
