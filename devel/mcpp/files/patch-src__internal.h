--- src/internal.H.orig	2009-09-09 12:32:06.000000000 -0700
+++ src/internal.H	2009-09-09 12:32:08.000000000 -0700
@@ -556,7 +556,3 @@
 #pragma GCC visibility pop
 #endif
 #endif
-
-#if HOST_HAVE_STPCPY
-extern char *   stpcpy( char * dest, const char * src);
-#endif
