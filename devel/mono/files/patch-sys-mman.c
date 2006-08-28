--- support/sys-mman.c.orig	2006-08-27 19:57:09.000000000 -0700
+++ support/sys-mman.c	2006-08-27 19:58:44.000000000 -0700
@@ -8,6 +8,7 @@
  */
 
 #define _XOPEN_SOURCE 600
+#undef _NONSTD_SOURCE
 
 #include <sys/types.h>
 #include <sys/mman.h>
