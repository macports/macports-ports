--- assuan/funopen.c.orig	2005-09-08 08:42:30.000000000 -0600
+++ assuan/funopen.c	2006-03-22 18:41:18.000000000 -0700
@@ -22,6 +22,8 @@
 #include <config.h>
 #endif
 
+#ifndef HAVE_FUNOPEN
+
 #include <stdio.h>
 
 
@@ -61,3 +63,6 @@
 #else
 #error No known way to implement funopen.
 #endif
+
+#endif
+
