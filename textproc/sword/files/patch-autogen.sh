--- ../sword-1.5.7.orig/autogen.sh	Wed Nov 12 08:40:48 2003
+++ autogen.sh	Tue May 11 22:27:41 2004
@@ -1,7 +1,8 @@
 #!/bin/sh
 echo "*** Sword build system generation"
+ulimit -s 65536
 echo "*** Recreating libtool"
-libtoolize --force --copy;
+glibtoolize --force --copy;
 ACLOCAL="$AUTODIR""aclocal"
 echo "*** Recreating aclocal.m4"
 echo "$ACLOCAL"
