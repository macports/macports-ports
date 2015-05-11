#!/bin/sh

set -e

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd "$srcdir"

if automake-1.11 --version > /dev/null 2>&1; then
  automake_suffix='-1.11'
else
  automake_suffix=''
fi

mkdir -p m4 build-aux
intltoolize --force
aclocal${automake_suffix}
autoheader
automake${automake_suffix} --add-missing
autoconf

CFLAGS=${CFLAGS=-ggdb}
LDFLAGS=${LDFLAGS=-Wl,-O1}
export CFLAGS LDFLAGS

cd "$olddir"

if test -z "$NOCONFIGURE"; then
  "$srcdir"/configure "$@"
fi
