#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

# (test -f $srcdir/configure.ac \
#   && test -f $srcdir/gnome-applets.doap) || {
#     echo -n "**Error**: Directory "\`$srcdir\'" does not look like the"
#     echo " top-level gnome-applets directory"
#     exit 1
# }

which gnome-autogen.sh || {
    echo "You need to install gnome-common."
    exit 1
}

REQUIRED_AUTOMAKE_VERSION=1.9
REQUIRED_YELP_TOOLS_VERSION=3.1.1

. gnome-autogen.sh
