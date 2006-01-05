--- libhttpd/src/select.h.orig	2005-01-05 10:18:47.000000000 +1100
+++ libhttpd/src/select.h	2006-01-05 19:41:28.000000000 +1100
@@ -37,7 +37,7 @@
 #include "httpd_priv.h"
 
 #ifdef __APPLE__
-	typedef int socklen_t;
+	typedef __uint32_t socklen_t;
 #endif
 
 #ifdef __sgi__
