--- pine4.44/pico/osdep/os-osx.h.orig	Mon Nov  4 09:34:14 2002
+++ pine4.44/pico/osdep/os-osx.h	Mon Nov  4 09:34:18 2002
@@ -181,7 +181,8 @@
 /*
  * Make sys_errlist visible
  */
+#ifndef _STDIO_H_
 extern int   sys_nerr;
-
+#endif
 
 #endif /* _PICO_OS_INCLUDED */
