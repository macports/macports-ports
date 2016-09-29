#!/bin/sh
# Run this to generate all the initial makefiles, etc.
test -n "$srcdir" || srcdir=$(dirname "$0")
test -n "$srcdir" || srcdir=.

olddir=$(pwd)

cd $srcdir

(test -f configure.ac) || {
        echo "*** ERROR: Directory '$srcdir' does not look like the top-level project directory ***"
        exit 1
}

# shellcheck disable=SC2016
PKG_NAME=$(autoconf --trace 'AC_INIT:$1' configure.ac)

aclocal --install || exit 1
gtkdocize --copy || exit 1
intltoolize --force --copy --automake || exit 1
autoreconf --verbose --force --install || exit 1

cd "$olddir"
if [ "$NOCONFIGURE" = "" ]; then
        # If no arguments are given, use those used with distcheck
        # equally, use the JHBuild prefix if it is available otherwise fall
        # back to the default (/usr/local)
        if [ $# -eq 0 ] ; then
                echo "Using distcheck arguments, none were supplied..."

                if test -n "$JHBUILD_PREFIX" ; then
                        echo "Using JHBuild prefix ('$JHBUILD_PREFIX')"
                        NEW_PREFIX="--prefix $JHBUILD_PREFIX --with-bash-completion-dir=$JHBUILD_PREFIX/share/bash-completion/completions"
                fi

                NEW_ARGS="\
                        --disable-nautilus-extension \
                        --enable-unit-tests \
                        --enable-functional-tests \
                        --enable-gtk-doc \
                        --enable-introspection \
                        --disable-miner-rss \
                        --disable-miner-evolution \
                        --disable-miner-thunderbird \
                        --disable-miner-firefox \
                        --enable-poppler \
                        --enable-exempi \
                        --enable-libiptcdata \
                        --enable-libjpeg \
                        --enable-libtiff \
                        --enable-libvorbis \
                        --enable-libflac \
                        --enable-libgsf \
                        --enable-playlist \
                        --enable-tracker-preferences \
                        --enable-enca"

                set -- $NEW_PREFIX $NEW_ARGS
        fi

        $srcdir/configure "$@" || exit 1

        if [ "$1" = "--help" ]; then exit 0 else
                echo "Now type 'make' to compile $PKG_NAME" || exit 1
        fi
else
        echo "Skipping configure process."
fi
