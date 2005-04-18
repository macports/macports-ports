--- lib/listfile.c.orig	2005-04-18 10:03:16.000000000 -0400
+++ lib/listfile.c	2005-04-18 10:03:19.000000000 -0400
@@ -89,10 +89,6 @@
 #define S_ISLNK(m) (((m) & S_IFMT) == S_IFLNK)
 #endif
 
-#if defined(S_ISLNK)
-int readlink ();
-#endif
-
 /* Get or fake the disk device blocksize.
    Usually defined by sys/param.h (if at all).  */
 #ifndef DEV_BSIZE
