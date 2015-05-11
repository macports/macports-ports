#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="gsettings-desktop-schemas"
REQUIRED_AUTOMAKE_VERSION=1.9
REQUIRED_M4MACROS=

which gnome-autogen.sh || {
    echo "You need to install gnome-common."
    exit 1
}

. gnome-autogen.sh
