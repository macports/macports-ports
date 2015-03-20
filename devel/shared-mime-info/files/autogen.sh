#!/bin/sh
# Run this to generate all the initial makefiles, etc.

echo "autogen.sh: running: intltoolize --force"
intltoolize --force || exit 1
autoreconf -vif || exit 1

if test -z "$NOCONFIGURE"; then
    ./configure "$@" && echo "Now type \`make' to compile" || exit 1
fi
