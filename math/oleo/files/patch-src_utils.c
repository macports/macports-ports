--- src/utils.c.orig	Tue Feb 13 16:38:06 2001
+++ src/utils.c	Thu Feb 19 16:30:39 2004
@@ -66,7 +66,9 @@
 #define _IOSTRG 0
 #endif
 
+#ifndef HAVE_SYS_ERRLIST
 extern int sys_nerr;
+#endif
 
 struct id
   {
