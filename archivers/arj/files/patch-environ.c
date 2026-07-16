--- environ.c-orig	Fri Jun 18 20:19:36 2004
+++ environ.c	Tue Aug  3 12:45:33 2004
@@ -64,7 +64,8 @@
  #elif defined(__QNXNTO__)
   #include <sys/statvfs.h>
  #else
-  #include <sys/statfs.h>
+//  #include <sys/statfs.h>
+#include <sys/mount.h>
  #endif
 #endif
 #ifdef TILED
