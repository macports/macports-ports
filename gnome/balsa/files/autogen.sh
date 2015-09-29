#! /bin/sh
# bootstrap file to be used when autogen.sh fails.
echo "Running gettextize...  Ignore non-fatal messages."
glib-gettextize --force --copy || exit 1
echo "running intltoolize..."
[ -d m4 ] || mkdir m4
intltoolize --copy --force --automake || exit 1
echo "Running libtoolize..."
glibtoolize --force || exit 1
echo "Running aclocal..."
aclocal || exit 1
echo "Running autoconf..."
autoconf || exit 1
echo "Running autoheader..."
autoheader || exit 1
echo "Running automake..."
automake --gnu --add-missing --copy || exit 1
echo "Running configure $* ..."
exec ./configure "$@"
