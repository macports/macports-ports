#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

(test -f $srcdir/configure.ac) || {
    echo "**Error**: Directory "\`$srcdir\'" does not look like the top-level project directory"
    exit 1
}

olddir=`pwd`
cd $srcdir

PKG_NAME=`autoconf --trace "AC_INIT:$1" "$srcdir/configure.ac"`
ACLOCAL_FLAGS="-I libgd $ACLOCAL_FLAGS"

if [ "$#" = 0 -a "x$NOCONFIGURE" = "x" ]; then
    echo "**Warning**: I am going to run \`configure' with no arguments." >&2
    echo "If you wish to pass any to it, please specify them on the" >&2
    echo \`$0\'" command line." >&2
    echo "" >&2
fi

# git submodule update --init --recursive

# if the AC_CONFIG_MACRO_DIR() macro is used, create that directory
# This is a automake bug fixed in automake 1.13.2
# See http://debbugs.gnu.org/cgi/bugreport.cgi?bug=13514
m4dir=`autoconf --trace 'AC_CONFIG_MACRO_DIR:$1'`
if [ -n "$m4dir" ]; then
    mkdir -p $m4dir
fi

set -x

intltoolize --force --copy --automake || exit 1
autoreconf --verbose --force --install -Wno-portability || exit 1

cd $olddir

if [ "$NOCONFIGURE" = "" ]; then
        $srcdir/configure "$@" || exit 1

        if [ "$1" = "--help" ]; then exit 0 else
                echo "Now type \`make\' to compile $PKG_NAME" || exit 1
        fi
else
        echo "Skipping configure process."
fi

set +x
