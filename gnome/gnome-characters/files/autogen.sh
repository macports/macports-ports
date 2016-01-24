#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

ACLOCAL_FLAGS="${ACLOCAL_FLAGS}"

test -f $srcdir/configure.ac || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level gnome-characters directory"
    exit 1
}

which gnome-autogen.sh || {
    echo "You need to install gnome-common from GNOME Git (or from"
    echo "your OS vendor's package manager)."
    exit 1
}

# gllib/unictype contains gperf generated source code
: ${GPERF=gperf}
"$GPERF" --version 2>&1 >/dev/null || {
    echo "You need to install gperf."
    exit 1
}

(cd "$srcdir" ;
test -d m4 || mkdir m4/ ;
# git submodule update --init --recursive ;
test -z "$GNULIB_SRCDIR" || \
    "$GNULIB_SRCDIR"/gnulib-tool --import \
		    --source-base=gllib --m4-base=glm4 --tests-base=gltests \
		    --libtool --no-vc-files \
		    libunistring-optional \
		    unicase/tolower \
		    unicase/toupper \
		    unicase/totitle \
		    unictype/block-all \
		    unictype/category-all \
		    unictype/ctype-print \
		    unictype/mirror \
		    unictype/property-all \
		    unictype/scripts-all \
		    uninorm/canonical-decomposition \
		    unistr/u32-to-u8 \
		    unitypes \
		    uniname/uniname ;
)
. gnome-autogen.sh

