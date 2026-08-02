#!/bin/sh

srcdir=`dirname $0`
[ -z "$srcdir" ] && srcdir=.

PKG_NAME=libepc

if [ ! -f "$srcdir/libepc/publisher.c" ]; then
 echo "$srcdir doesn't look like source directory for $PKG_NAME" >&2
 exit 1
fi

. gnome-autogen.sh
