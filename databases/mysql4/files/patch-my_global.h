--- include/my_global.h.orig    2005-05-13 04:32:00.000000000 -0700
+++ include/my_global.h 2005-06-05 00:44:26.000000000 -0700
@@ -264,7 +264,7 @@
 # endif
 #endif /* TIME_WITH_SYS_TIME */
 #ifdef HAVE_UNISTD_H
-#if defined(HAVE_OPENSSL) && !defined(__FreeBSD__) && !defined(NeXT) && !defined(__OpenBSD__)
+#if defined(HAVE_OPENSSL) && !defined(__FreeBSD__) && !defined(NeXT) && !defined(__OpenBSD__) && !defined(__APPLE__)
 #define crypt unistd_crypt
 #endif
 #include <unistd.h>
