#! /bin/sh
# bootstrap file to be used when autogen.sh fails.
test -n "$srcdir" || srcdir=`dirname "$0"`
test -n "$srcdir" || srcdir=.

olddir=`pwd`

cd $srcdir

echo "Running gettextize...  Ignore non-fatal messages."
glib-gettextize --force --copy || exit 1
echo "running intltoolize..."
[ -d m4 ] || mkdir m4
intltoolize --copy --force --automake || exit 1
echo "Running glibtoolize..."
glibtoolize --force || exit 1
echo "Running aclocal..."
aclocal || exit 1
echo "Running autoconf..."
autoconf || exit 1
echo "Running autoheader..."
autoheader || exit 1
echo "Running automake..."
automake --gnu --add-missing --copy || exit 1
gsed -i.orig -e "2558,2559d" configure

cd $olddir

echo "Running configure $* ..."
exec $srcdir/configure "$@"
