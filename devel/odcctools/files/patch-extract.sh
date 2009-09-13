--- extract.sh.orig	2009-09-13 11:24:01.000000000 -0700
+++ extract.sh	2009-09-13 11:24:14.000000000 -0700
@@ -44,11 +44,7 @@
 
 
 
-if [ "`tar --help | grep -- --strip-components 2> /dev/null`" ]; then
-    TARSTRIP=--strip-components
-else
-    TARSTRIP=--strip-path
-fi
+TARSTRIP=--strip-components
 
 PATCHFILESDIR=${TOPSRCDIR}/patches
 
