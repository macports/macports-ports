#!/bin/sh
# Run this to generate all the initial makefiles, etc.

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd $srcdir

PKG_NAME="GNOME Dictionary"

rm -rf autom4te.cache

mkdir -p m4

GTKDOCIZE=$(which gtkdocize 2>/dev/null)
if test -z $GTKDOCIZE; then
        echo "*** You don't have gtk-doc installed, and thus won't be able to generate the documentation. ***"
        rm -f gtk-doc.make
        cat > gtk-doc.make <<EOF
EXTRA_DIST =
CLEANFILES =
EOF
else
        gtkdocize || exit $?
fi

INTLTOOLIZE=$(which intltoolize 2>/dev/null)
if test -z $INTLTOOLIZE; then
        echo "*** No intltoolize found, please install intltool ***"
        exit 1
else
        intltoolize --force --copy --automake || exit $?
fi

AUTORECONF=$(which autoreconf 2>/dev/null)
if test -z $AUTORECONF; then
        echo "*** No autoreconf found, please install it ***"
        exit 1
else
        autoreconf --verbose --force --install -Wno-portability || exit $?
fi

# NOCONFIGURE is used by gnome-common
if test -z "$NOCONFIGURE"; then
        if test -z "$*"; then
                echo "I am going to run ./configure with no arguments - if you wish "
                echo "to pass any to it, please specify them on the $0 command line."
        fi
fi

cd "$olddir"
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"
