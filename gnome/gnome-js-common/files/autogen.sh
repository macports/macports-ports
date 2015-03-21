#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

PKG_NAME="gnome-js-common"

which gnome-autogen.sh || {
    echo "You need to install gnome-common and make"
    echo "sure the gnome-autogen.sh script is in your \$PATH."
    exit 1
}

. gnome-autogen.sh
