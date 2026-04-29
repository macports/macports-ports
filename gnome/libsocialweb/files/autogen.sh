#!/bin/sh

set -e

mkdir -p m4
gtkdocize
intltoolize --copy --force --automake
ACLOCAL="${ACLOCAL-aclocal} $ACLOCAL_FLAGS" autoreconf -v -i
test -n "$NOCONFIGURE" || ./configure $@
