#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

ORIGDIR=`pwd`
cd $srcdir
PROJECT=libsecret
TEST_TYPE=-f
FILE=libsecret/secret-value.c

DIE=0

have_libtool=false
if glibtoolize --version < /dev/null > /dev/null 2>&1 ; then
	libtool_version=`glibtoolize --version |
			 head -1 |
			 sed -e 's/^\(.*\)([^)]*)\(.*\)$/\1\2/g' \
			     -e 's/^[^0-9]*\([0-9.][0-9.]*\).*/\1/'`
	case $libtool_version in
	    2.2*)
		have_libtool=true
		;;
	    2.4*)
		have_libtool=true
		;;
	esac
fi
if $have_libtool ; then : ; else
	echo
	echo "You must have libtool >= 2.2 installed to compile $PROJECT."
	echo "Install the appropriate package for your distribution,"
	echo "or get the source tarball at http://ftp.gnu.org/gnu/libtool/"
	DIE=1
fi

(autoconf --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have autoconf installed to compile $PROJECT."
	echo "Install the appropriate package for your distribution,"
	echo "or get the source tarball at http://ftp.gnu.org/gnu/autoconf/"
	DIE=1
}

AUTOMAKE_VERSIONS="1.15 1.14 1.13 1.12 1.11 1.10"
for version in $AUTOMAKE_VERSIONS; do
	if automake-$version --version < /dev/null > /dev/null 2>&1 ; then
		AUTOMAKE=automake-$version
		ACLOCAL=aclocal-$version
		break
	fi
done

if test -z "$AUTOMAKE"; then
	echo
	echo "You must have one of automake $AUTOMAKE_VERSIONS to compile $PROJECT."
	echo "Install the appropriate package for your distribution,"
	echo "or get the source tarball at http://ftp.gnu.org/gnu/automake/"
	DIE=1
fi

if test "$DIE" -eq 1; then
	exit 1
fi

test $TEST_TYPE $FILE || {
	echo "You must run this script in the top-level $PROJECT directory"
	exit 1
}

# NOCONFIGURE is used by gnome-common; support both
if ! test -z "$AUTOGEN_SUBDIR_MODE"; then
    NOCONFIGURE=1
fi

if test -z "$NOCONFIGURE"; then
        if test -z "$*"; then
                echo "I am going to run ./configure with no arguments - if you wish "
                echo "to pass any to it, please specify them on the $0 command line."
        fi
fi

rm -rf autom4te.cache

# README and INSTALL are required by automake, but may be deleted by clean
# up rules. to get automake to work, simply touch these here, they will be
# regenerated from their corresponding *.in files by ./configure anyway.
touch README INSTALL

$ACLOCAL -I build/m4 $ACLOCAL_FLAGS || exit $?

glibtoolize --force || exit $?
intltoolize --force --copy || exit $?

gtkdocize || exit $?

autoheader || exit $?

$AUTOMAKE --add-missing || exit $?
autoconf || exit $?
cd $ORIGDIR || exit $?

if test -z "$NOCONFIGURE"; then
        $srcdir/configure $AUTOGEN_CONFIGURE_ARGS "$@" || exit $?

        echo 
        echo "Now type 'make' to compile $PROJECT."
fi
