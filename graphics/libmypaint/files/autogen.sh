#!/bin/sh

# This script does all the magic calls to automake/autoconf and
# friends that are needed to configure a git clone. As described in
# the file HACKING you need a couple of extra tools to run this script
# successfully.
#
# If you are compiling from a released tarball you don't need these
# tools and you shouldn't use this script.  Just call ./configure
# directly.

ACLOCAL=${ACLOCAL-aclocal-1.13}
AUTOCONF=${AUTOCONF-autoconf}
AUTOHEADER=${AUTOHEADER-autoheader}
AUTOMAKE=${AUTOMAKE-automake-1.13}
LIBTOOLIZE=${LIBTOOLIZE-libtoolize}

AUTOCONF_REQUIRED_VERSION=2.62
AUTOMAKE_REQUIRED_VERSION=1.13
INTLTOOL_REQUIRED_VERSION=0.40.1
LIBTOOL_REQUIRED_VERSION=1.5
LIBTOOL_WIN32_REQUIRED_VERSION=2.2


PROJECT="libmypaint"
TEST_TYPE=-f
FILE=libmypaint.c


srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.
ORIGDIR=`pwd`
cd $srcdir


check_version ()
{
    VERSION_A=$1
    VERSION_B=$2

    save_ifs="$IFS"
    IFS=.
    set dummy $VERSION_A 0 0 0
    MAJOR_A=$2
    MINOR_A=$3
    MICRO_A=$4
    set dummy $VERSION_B 0 0 0
    MAJOR_B=$2
    MINOR_B=$3
    MICRO_B=$4
    IFS="$save_ifs"

    if expr "$MAJOR_A" = "$MAJOR_B" > /dev/null; then
        if expr "$MINOR_A" \> "$MINOR_B" > /dev/null; then
           echo "yes (version $VERSION_A)"
        elif expr "$MINOR_A" = "$MINOR_B" > /dev/null; then
            if expr "$MICRO_A" \>= "$MICRO_B" > /dev/null; then
               echo "yes (version $VERSION_A)"
            else
                echo "Too old (version $VERSION_A)"
                DIE=1
            fi
        else
            echo "Too old (version $VERSION_A)"
            DIE=1
        fi
    elif expr "$MAJOR_A" \> "$MAJOR_B" > /dev/null; then
	echo "Major version might be too new ($VERSION_A)"
    else
	echo "Too old (version $VERSION_A)"
	DIE=1
    fi
}

echo
echo "I am testing that you have the tools required to build"
echo "$PROJECT from git. This test is not foolproof."
echo

DIE=0

OS=`uname -s`
case $OS in
    *YGWIN* | *INGW*)
	echo "Looks like Win32, you will need libtool $LIBTOOL_WIN32_REQUIRED_VERSION or newer."
	echo
	LIBTOOL_REQUIRED_VERSION=$LIBTOOL_WIN32_REQUIRED_VERSION
	;;
esac

echo -n "checking for libtool >= $LIBTOOL_REQUIRED_VERSION ... "
if ($LIBTOOLIZE --version) < /dev/null > /dev/null 2>&1; then
   LIBTOOLIZE=$LIBTOOLIZE
elif (glibtoolize --version) < /dev/null > /dev/null 2>&1; then
   LIBTOOLIZE=glibtoolize
else
    echo
    echo "  You must have libtool installed to compile $PROJECT."
    echo "  Install the appropriate package for your distribution,"
    echo "  or get the source tarball at ftp://ftp.gnu.org/pub/gnu/"
    echo
    DIE=1
fi

if test x$LIBTOOLIZE != x; then
    VER=`$LIBTOOLIZE --version \
         | grep libtool | sed "s/.* \([0-9.]*\)[-a-z0-9]*$/\1/"`
    check_version $VER $LIBTOOL_REQUIRED_VERSION
fi

echo -n "checking for autoconf >= $AUTOCONF_REQUIRED_VERSION ... "
if ($AUTOCONF --version) < /dev/null > /dev/null 2>&1; then
    VER=`$AUTOCONF --version | head -n 1 \
         | grep -iw autoconf | sed "s/.* \([0-9.]*\)[-a-z0-9]*$/\1/"`
    check_version $VER $AUTOCONF_REQUIRED_VERSION
else
    echo
    echo "  You must have autoconf installed to compile $PROJECT."
    echo "  Download the appropriate package for your distribution,"
    echo "  or get the source tarball at ftp://ftp.gnu.org/pub/gnu/autoconf/"
    echo
    DIE=1;
fi


echo -n "checking for automake >= $AUTOMAKE_REQUIRED_VERSION ... "
if ($AUTOMAKE --version) < /dev/null > /dev/null 2>&1; then
   AUTOMAKE=$AUTOMAKE
   ACLOCAL=$ACLOCAL
elif (automake-1.16 --version) < /dev/null > /dev/null 2>&1; then
   AUTOMAKE=automake-1.16
   ACLOCAL=aclocal-1.16
elif (automake-1.15 --version) < /dev/null > /dev/null 2>&1; then
   AUTOMAKE=automake-1.15
   ACLOCAL=aclocal-1.15
elif (automake-1.14 --version) < /dev/null > /dev/null 2>&1; then
   AUTOMAKE=automake-1.14
   ACLOCAL=aclocal-1.14
elif (automake-1.13 --version) < /dev/null > /dev/null 2>&1; then
   AUTOMAKE=automake-1.13
   ACLOCAL=aclocal-1.13
else
    echo
    echo "  You must have automake $AUTOMAKE_REQUIRED_VERSION or newer installed to compile $PROJECT."
    echo "  Download the appropriate package for your distribution,"
    echo "  or get the source tarball at ftp://ftp.gnu.org/pub/gnu/automake/"
    echo
    DIE=1
fi

if test x$AUTOMAKE != x; then
    VER=`$AUTOMAKE --version \
         | grep automake | sed "s/.* \([0-9.]*\)[-a-z0-9]*$/\1/"`
    check_version $VER $AUTOMAKE_REQUIRED_VERSION
fi


echo -n "checking for intltool >= $INTLTOOL_REQUIRED_VERSION ... "
if (intltoolize --version) < /dev/null > /dev/null 2>&1; then
    VER=`intltoolize --version \
         | grep intltoolize | sed "s/.* \([0-9.]*\)/\1/"`
    check_version $VER $INTLTOOL_REQUIRED_VERSION
else
    echo
    echo "  You must have intltool installed to compile $PROJECT."
    echo "  Get the latest version from"
    echo "  ftp://ftp.gnome.org/pub/GNOME/sources/intltool/"
    echo
    DIE=1
fi

if test "$DIE" -eq 1; then
    echo
    echo "Please install/upgrade the missing tools and call me again."
    echo	
    exit 1
fi


test $TEST_TYPE $FILE || {
    echo
    echo "You must run this script in the top-level $PROJECT directory."
    echo
    exit 1
}


if test -z "$ACLOCAL_FLAGS"; then
    m4list="glib-2.0.m4 glib-gettext.m4 intltool.m4 pkg.m4"
    acdir0=`$ACLOCAL --print-ac-dir`
    acpaths=`echo "${ACLOCAL_PATH}:${acdir0}" | sed 's/:/ /g'`
    for file in $m4list; do
        file_path=""
        for acdir in $acpaths; do
            if test -f "${acdir}/${file}"; then
                file_path="$acdir/$file"
                break
            fi
        done
        if test "x$file_path" = "x"; then
            echo "WARNING: cannot find $file in aclocal's search path."
            echo "         You may see fatal macro warnings below."
            echo "         I looked in: $acpaths"
            echo "         If these files are installed in /some/dir, set the "
            echo "         ACLOCAL_FLAGS environment variable to \"-I /some/dir\","
            echo "         or append \":/some/dir\" to ACLOCAL_PATH,"
            echo "         or install $acdir0/$file."
            echo
        fi
    done
fi

rm -rf autom4te.cache

$ACLOCAL $ACLOCAL_FLAGS
RC=$?
if test $RC -ne 0; then
   echo "$ACLOCAL gave errors. Please fix the error conditions and try again."
   exit $RC
fi

$LIBTOOLIZE --force || exit $?

# optionally feature autoheader
($AUTOHEADER --version)  < /dev/null > /dev/null 2>&1 && $AUTOHEADER || exit 1


# Generate headers from brushsettings.json which defines "Settings"
# (mostly visually-meaningful outputs that cause the brush engine to
# make blobs), "Inputs" (data from the client application like zoom,
# pressure, position, or tilt), and "States" (internal state counters
# updated and used by the brush engine over time).
#
# The generated files are included in "make dist" tarballs, like the
# configure script. The internal-only brushsettings-gen.h is also used
# as the source of strings for gettext.

python2 generate.py mypaint-brush-settings-gen.h brushsettings-gen.h

# The MyPaint code no longer needs the .json file at runtime, and it is
# not installed as data.

$AUTOMAKE --add-missing || exit $?
$AUTOCONF || exit $?

intltoolize --automake || exit $?


cd $ORIGDIR
