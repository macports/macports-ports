#!/bin/sh

set -e # exit on errors

REQUIRED_AUTOMAKE_VERSION=1.9

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.
mkdir -p m4
PKG_NAME=GeoClue

gtkdocize
intltoolize --force --copy
autoreconf -v --force --install

if [ -z "$NOCONFIGURE" ]; then
    "$srcdir"/configure --enable-maintainer-mode --enable-debug ${1+"$@"}
fi
