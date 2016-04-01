#!/bin/sh
# Run this to generate all the initial makefiles, etc.
test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`

cd $srcdir

(test -f configure.ac) || {
        echo "*** ERROR: Directory '$srcdir' does not look like the top-level project directory ***"
        exit 1
}

aclocal --install || exit 1
gtkdocize --copy || exit 1
intltoolize --force --copy --automake || exit 1
sed -e 's/subdir = po/subdir = po-locations/' \
    -e 's/GETTEXT_PACKAGE = @GETTEXT_PACKAGE@/GETTEXT_PACKAGE = libgweather-locations/' \
    po/Makefile.in.in > po-locations/Makefile.in.in
autoreconf --verbose --force --install -Wno-portability || exit 1

cd $olddir
if [ "$NOCONFIGURE" = "" ]; then
        $srcdir/configure "$@" || exit 1
        echo "Now type 'make' to compile."
else
        echo "Skipping configure process."
fi
