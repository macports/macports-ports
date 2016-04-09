#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

(test -f $srcdir/Makefile.am && test -d $srcdir/pan) || {
    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
    echo " top-level Pan directory"
    exit 1
}

which gnome-autogen.sh || {
    echo "You need to install gnome-common module and make"
    echo "sure the gnome-autogen.sh script is in your \$PATH."
    exit 1
}

. gnome-autogen.sh
