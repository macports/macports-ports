--- ../pgdispd/proccom.c.orig	Mon Aug 22 14:33:35 1994
+++ ../pgdispd/proccom.c	Tue Sep 14 16:38:57 2004
@@ -93,7 +93,7 @@
 #include <sys/types.h>
 #include <netinet/in.h>
 
-#ifndef VMS
+#if !defined(VMS) && !defined(__APPLE__)
 #include <values.h>
 #endif
 
