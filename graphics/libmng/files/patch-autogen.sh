--- autogen.sh.orig	Sat Dec  6 19:11:19 2003
+++ autogen.sh	Sat Dec  6 19:14:07 2003
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

