#!/bin/sh
# Run this to generate all the initial makefiles, etc.

PKG_NAME="libgweather"

test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`
cd "$srcdir"

test -f configure.ac || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level $PKG_NAME directory"
    exit 1
}

mkdir m4/

GTKDOCIZE=$(which gtkdocize 2>/dev/null)
if test -z $GTKDOCIZE; then
        echo "You don't have gtk-doc installed, and thus won't be able to generate the documentation."
        rm -f gtk-doc.make
        cat > gtk-doc.make <<EOF
EXTRA_DIST =
CLEANFILES =
EOF
else
        gtkdocize || exit $?
fi

AUTORECONF=`which autoreconf`
if test -z $AUTORECONF; then
        echo "*** No autoreconf found, please install it ***"
        exit 1
fi

# README and INSTALL are required by automake, but may be deleted by clean
# up rules. to get automake to work, simply touch these here, they will be
# regenerated from their corresponding *.in files by ./configure anyway.
touch README INSTALL

autoreconf --force --install --verbose || exit $?
intltoolize --force --automake || exit $?

# Replace autopoint Makefile.in.in with intltool's one
sed -e 's/subdir = po/subdir = po-locations/' \
    -e 's/GETTEXT_PACKAGE = @GETTEXT_PACKAGE@/GETTEXT_PACKAGE = libgweather-locations/' \
    po/Makefile.in.in > po-locations/Makefile.in.in

# Now configure, if asked
cd "$olddir"
test -n "$NOCONFIGURE" || "$srcdir/configure" "$@"

