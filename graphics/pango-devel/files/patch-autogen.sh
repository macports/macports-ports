--- autogen.sh.old	2005-12-06 14:30:33.000000000 +0100
+++ autogen.sh	2005-12-06 14:31:27.000000000 +0100
@@ -1,6 +1,8 @@
 #!/bin/sh
 # Run this to generate all the initial makefiles, etc.
 
+PATH=$DARWINPORTS/bin:$PATH
+
 srcdir=`dirname $0`
 test -z "$srcdir" && srcdir=.
 
@@ -12,9 +14,11 @@
 
 DIE=0
 
+LIBTOOLIZE=${LIBTOOLIZE-libtoolize}
+
 have_libtool=false
-if libtoolize --version < /dev/null > /dev/null 2>&1 ; then
-	libtool_version=`libtoolize --version | sed 's/^[^0-9]*\([0-9].[0-9.]*\).*/\1/'`
+if $LIBTOOLIZE --version < /dev/null > /dev/null 2>&1 ; then
+	libtool_version=`$LIBTOOLIZE --version | sed 's/^[^0-9]*\([0-9].[0-9.]*\).*/\1/'`
 	case $libtool_version in
 	    1.4*|1.5*)
 		have_libtool=true
@@ -45,12 +49,12 @@
 	DIE=1
 }
 
-if automake-1.7 --version < /dev/null > /dev/null 2>&1 ; then
-    AUTOMAKE=automake-1.7
-    ACLOCAL=aclocal-1.7
+if automake-1.9 --version < /dev/null > /dev/null 2>&1 ; then
+    AUTOMAKE=automake-1.9
+    ACLOCAL=aclocal-1.9
 else
 	echo
-	echo "You must have automake 1.7.x installed to compile $PROJECT."
+	echo "You must have automake 1.9.x installed to compile $PROJECT."
 	echo "Install the appropriate package for your distribution,"
 	echo "or get the source tarball at http://ftp.gnu.org/gnu/automake/"
 	DIE=1
@@ -76,7 +80,7 @@
 
 $ACLOCAL $ACLOCAL_FLAGS || exit 1
 
-libtoolize --force || exit $?
+$LIBTOOLIZE --force || exit $?
 gtkdocize || exit $?
 
 autoheader || exit $?
