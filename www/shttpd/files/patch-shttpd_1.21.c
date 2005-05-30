--- shttpd_1.21.c.orig	2005-05-30 01:12:32.000000000 -0400
+++ shttpd_1.21.c	2005-05-30 01:12:42.000000000 -0400
@@ -152,7 +152,7 @@
 #endif	/* _WIN32 */
 
 /* Darwin and Win32 do not have socklen_t */
-#if defined(__APPLE_CC__) || defined(_WIN32)
+#if (defined(__APPLE_CC__) && !defined(_SOCKLEN_T)) || defined(_WIN32)
 typedef int socklen_t;
 #endif
 
