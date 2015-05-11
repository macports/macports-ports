#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

REQUIRED_AUTOMAKE_VERSION=1.9
REQUIRED_M4MACROS=introspection.m4

#(test -f $srcdir/configure.ac \
#  && test -f $srcdir/gnome-panel.doap) || {
#    echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
#    echo " top-level gnome-panel directory"
#    exit 1
#}

which gnome-autogen.sh || {
    echo "You need to install gnome-common."
    exit 1
}

. gnome-autogen.sh
