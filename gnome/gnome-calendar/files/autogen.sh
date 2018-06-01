#!/bin/sh
# Run this to generate all the initial makefiles, etc.
set -e

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

olddir=`pwd`
cd $srcdir

mkdir -p m4
autoreconf --verbose --force --install || exit $?
intltoolize --force --copy --automake || exit $?

if test -z "$NOCONFIGURE"; then
    run_configure=true
    for arg in $*; do
	case $arg in
            --no-configure)
		run_configure=false
		;;
            *)
		;;
	esac
    done
else
    run_configure=false
fi

cd "$olddir"
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
