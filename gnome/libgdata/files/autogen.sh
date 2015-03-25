#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME=libgdata

(test -f $srcdir/configure.ac) || {
	echo "**Error**: Directory "\`$srcdir\'" does not look like the top-level $PKG_NAME directory"
	exit 1
}

if [ "$#" = 0 -a "x$NOCONFIGURE" = "x" ]; then
	echo "**Warning**: I am going to run \`configure' with no arguments." >&2
	echo "If you wish to pass any to it, please specify them on the" >&2
	echo \`$0\'" command line." >&2
	echo "" >&2
fi

# if the AC_CONFIG_MACRO_DIR() macro is used, create that directory
# This is a automake bug fixed in automake 1.13.2
# See http://debbugs.gnu.org/cgi/bugreport.cgi?bug=13514
if [ -n "m4" ]; then
	mkdir -p m4
fi

set -x

gtkdocize --copy || exit 1
intltoolize --force --copy --automake || exit 1
autoreconf --verbose --force --install -Wno-portability || exit 1

if test x$NOCONFIGURE = x; then
	$srcdir/configure "$@" && \
	echo "Now type \`make\' to compile $PKG_NAME" || exit 1
else
	echo "Skipping configure process."
fi

set +x
