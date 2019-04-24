#!/bin/sh 

# This script does all the magic calls to automake/autoconf and
# friends that are needed to configure a cvs checkout.  You need a
# couple of extra tools to run this script successfully.
#
# If you are compiling from a released tarball you don't need these
# tools and you shouldn't use this script.  Just call ./configure
# directly.


PROJECT="The GIMP Animation Package"
TEST_TYPE=-f
FILE="gap/gap_main.c"

AUTOCONF_REQUIRED_VERSION=2.54
AUTOMAKE_REQUIRED_VERSION=1.7
GLIB_REQUIRED_VERSION=2.2.0
INTLTOOL_REQUIRED_VERSION=0.17


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
echo "I am testing that you have the required versions of autoconf,"
echo "automake and glib-gettextize and intltoolize."
echo

DIE=0


echo -n "checking for autoconf >= $AUTOCONF_REQUIRED_VERSION ... "
if (autoconf --version) < /dev/null > /dev/null 2>&1; then
    VER=`autoconf --version \
         | grep -iw autoconf | sed "s/.* \([0-9.]*\)[-a-z0-9]*$/\1/"`
    check_version $VER $AUTOCONF_REQUIRED_VERSION
else
    echo
    echo "  You must have autoconf installed to compile $PROJECT."
    echo "  Download the appropriate package for your distribution,"
    echo "  or get the source tarball at ftp://ftp.gnu.org/pub/gnu/autoconf/"
    echo
    DIE=1
fi


echo -n "checking for automake >= $AUTOMAKE_REQUIRED_VERSION ... "
if (automake-1.16 --version) < /dev/null > /dev/null 2>&1; then
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
elif (automake-1.12 --version) < /dev/null > /dev/null 2>&1; then
   AUTOMAKE=automake-1.12
   ACLOCAL=aclocal-1.12
elif (automake-1.11 --version) < /dev/null > /dev/null 2>&1; then
   AUTOMAKE=automake-1.11
   ACLOCAL=aclocal-1.11
elif (automake-1.10 --version) < /dev/null > /dev/null 2>&1; then
   AUTOMAKE=automake-1.10
   ACLOCAL=aclocal-1.10
elif (automake-1.9 --version) < /dev/null > /dev/null 2>&1; then
   AUTOMAKE=automake-1.9
   ACLOCAL=aclocal-1.9
elif (automake-1.8 --version) < /dev/null > /dev/null 2>&1; then
   AUTOMAKE=automake-1.8
   ACLOCAL=aclocal-1.8
elif (automake-1.7 --version) < /dev/null > /dev/null 2>&1; then
   AUTOMAKE=automake-1.7
   ACLOCAL=aclocal-1.7
else
    echo
    echo "  You must have automake 1.7 or newer installed to compile $PROJECT."
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


echo -n "checking for glib-gettextize >= $GLIB_REQUIRED_VERSION ... "
if (glib-gettextize --version) < /dev/null > /dev/null 2>&1; then
    VER=`glib-gettextize --version \
         | grep glib-gettextize | sed "s/.* \([0-9.]*\)/\1/"`
    check_version $VER $GLIB_REQUIRED_VERSION
else
    echo
    echo "  You must have glib-gettextize installed to compile $PROJECT."
    echo "  glib-gettextize is part of glib-2.0, so you should already"
    echo "  have it. Make sure it is in your PATH."
    DIE=1
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


echo
echo "I am going to run ./configure with the following arguments:"
echo
echo "  --enable-maintainer-mode $AUTOGEN_CONFIGURE_ARGS $@"
echo

if test -z "$*"; then
    echo "If you wish to pass additional arguments, please specify them "
    echo "on the $0 command line or set the AUTOGEN_CONFIGURE_ARGS "
    echo "environment variable."
    echo
fi


if test -z "$ACLOCAL_FLAGS"; then

    acdir=`$ACLOCAL --print-ac-dir`
    m4list="glib-gettext.m4 intltool.m4 pkg.m4"

    for file in $m4list
    do
	if [ ! -f "$acdir/$file" ]; then
	    echo
	    echo "WARNING: aclocal's directory is $acdir, but..."
            echo "         no file $acdir/$file"
            echo "         You may see fatal macro warnings below."
            echo "         If these files are installed in /some/dir, set the "
            echo "         ACLOCAL_FLAGS environment variable to \"-I /some/dir\""
            echo "         or install $acdir/$file."
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

# optionally feature autoheader
(autoheader --version)  < /dev/null > /dev/null 2>&1 && autoheader || exit 1

$AUTOMAKE --add-missing || exit $?
autoconf || exit $?

glib-gettextize --force || exit $?
intltoolize --force --automake || exit $?


cd $ORIGDIR

$srcdir/configure --enable-maintainer-mode $AUTOGEN_CONFIGURE_ARGS "$@"
RC=$?
if test $RC -ne 0; then
  echo
  echo "Configure failed or did not finish!"
  exit $RC
fi

echo
echo "Now type 'make' to compile $PROJECT."
