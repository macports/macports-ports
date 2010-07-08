--- libhttpd/src/select.h.orig	2006-03-05 08:00:38.000000000 -0600
+++ libhttpd/src/select.h	2010-07-07 22:45:33.000000000 -0500
@@ -38,7 +38,7 @@
 
 #ifdef __APPLE__
 #ifndef _SOCKLEN_T
-	typedef int socklen_t;
+	typedef __uint32_t socklen_t;
 #define _SOCKLEN_T
 #endif
 #endif
