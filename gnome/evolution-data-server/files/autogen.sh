#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

(test -f $srcdir/configure.ac \
  && test -f $srcdir/ChangeLog \
  && test -d $srcdir/calendar) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level evolution-data-server directory"
    exit 1
}

olddir=`pwd`
cd $srcdir

check_exists() {
	variable=`which $1`

	if test -z $variable; then
		echo "*** No $1 found, please intall it ***" >&2
		exit 1
	fi
}

check_exists aclocal
check_exists autoreconf
check_exists gtkdocize
check_exists intltoolize

m4dir=`autoconf --trace 'AC_CONFIG_MACRO_DIR:$1'`
if [ -n "$m4dir" ]; then
	mkdir -p $m4dir
fi

aclocal -I m4 || exit $?
gtkdocize --copy || exit $?
intltoolize --force --copy --automake || exit $?
autoreconf --verbose --force --install -Wno-portability || exit $?

cd $olddir
test -n "$NOCONFIGURE" || "$srcdir/configure" --disable-maintainer-mode "$@"
