--- bsdtar.c.orig	Sun Feb 20 04:01:01 2005
+++ bsdtar.c	Sun Feb 20 04:02:15 2005
@@ -67,6 +67,12 @@
 #define	_PATH_DEFTAPE "/dev/st0"
 #endif
 
+/* Alhough it's defined as such, Darwin has no /dev/nrst0. */
+#ifdef __APPLE__
+#undef _PATH_DEFTAPE
+#define _PATH_DEFTAPE "/dev/stdin"
+#endif
+
 #ifndef _PATH_DEFTAPE
 #define	_PATH_DEFTAPE "/dev/tape"
 #endif
