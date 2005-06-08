--- shttpd_1.22.c.orig	2005-06-08 19:15:11.000000000 -0400
+++ shttpd_1.22.c	2005-06-08 19:15:20.000000000 -0400
@@ -154,7 +154,7 @@
 #endif	/* _WIN32 */
 
 /* Darwin and Win32 do not have socklen_t */
-#if defined(__APPLE_CC__) || defined(_WIN32)
+#if defined(_WIN32)
 typedef int socklen_t;
 #endif
 
