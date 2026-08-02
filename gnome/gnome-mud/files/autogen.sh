#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

REQUIRED_AUTOMAKE_VERSION=1.9

PKG_NAME="gnome-mud"

which gnome-autogen.sh || {
	echo "You need to install gnome-common from the GNOME SVN"
	exit 1
}

. gnome-autogen.sh
