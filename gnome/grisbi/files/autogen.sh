#!/bin/bash
#
# autogen.sh glue for Grisbi
# $Id: autogen.sh,v 1.15 2009/08/23 07:27:46 pbiava Exp $
#
# Requires: automake, autoconf, dpkg-dev

#
# Check if autoconf and automake are installed
#
autoconf --version >/dev/null 2>&1
if [ $? -ne 0 ] ; then
	echo "Please install autoconf and rerun this script !"
	exit 1
fi
automake --version >/dev/null 2>&1
if [ $? -ne 0 ] ; then
	echo "Please install automake and rerun this script !"
	exit 1
fi
echo "automake and autoconf are installed"

# test for some distribution...

PATH_AUTOMAKE=$(ls -1d /usr/share/automake* 2>/dev/null | sort -gbu | tail -1)

if ! test -x $PATH_AUTOMAKE
then
	echo "Error: directory $PATH_AUTOMAKE does not exist"
fi

# fail on error
set -e

# Refresh GNU autotools toolchain.
for i in config.guess config.sub missing install-sh mkinstalldirs ; do
	test -r $PATH_AUTOMAKE/${i} && {
		rm -f ${i}
		cp $PATH_AUTOMAKE/${i} .
	}
	if test -r ${i} ; then
	    chmod 755 ${i}
	fi
done

#
# Apple's Developer Tools have a "libtool" that has nothing to do with
# the GNU libtool; they call the latter "glibtool".  They also call
# libtoolize "glibtoolize".
#
# Check for "glibtool" first.
# Borrowed from ethereal
#
LTVER=$(glibtool --version 2>/dev/null | grep ' libtool)' | \
    sed 's/.*libtool) \([0-9][0-9.]*\)[^ ]* .*/\1/')
if test -z "$LTVER"
then
	LTVER=$(libtoolize --version | grep ' libtool)' | \
	    sed 's/.*) \([0-9][0-9.]*\)[^ ]* .*/\1/' )
	LIBTOOLIZE=libtoolize
else
	LIBTOOLIZE=glibtoolize
fi
case "$LTVER" in
'' | 0.* | 1.[0-3]* )

  cat >&2 <<_EOF_

	You must have libtool 1.4 or later installed to compile $PROJECT.
	Download the appropriate package for your distribution/OS,
	or get the source tarball at ftp://ftp.gnu.org/pub/gnu/libtool/
_EOF_
  exit 1
  ;;
esac

$LIBTOOLIZE --force --copy

intltoolize --force --copy --automake

autoreconf --verbose --force --install

#
# Check if the configure script is created
#
echo
if [ ! -f ./configure ] ; then
	echo "The configure script was not created !"
	echo "You can't compile Grisbi."
	exit 1
fi
echo "The configure script was successfully created."
echo "To compile Grisbi, please run :"
echo "        ./configure"
echo "        make"
echo "	      make install"
echo

exit 0
