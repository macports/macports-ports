--- autogen.sh.orig	Sat Apr  3 17:44:13 2004
+++ autogen.sh	Sat Apr  3 17:44:32 2004
@@ -24,7 +24,7 @@
 aclocal
 
 echo "running libtoolize"
-libtoolize --automake
+glibtoolize --automake
 
 echo "running automake"
 automake --foreign --add-missing
@@ -33,6 +33,6 @@
 autoconf
 
 # and finally invoke our new configure
-./configure $*
+#./configure $*
 
 # end
