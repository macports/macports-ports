--- src/rateup.c.b	Sat Oct 19 02:06:55 2002
+++ src/rateup.c	Wed Jan 29 21:35:26 2003
@@ -45,7 +45,7 @@
 #define GFORM_GD gdImagePng 
 #endif
 /* BSDI 2.0.1 does not have malloc.h */
-#if !defined(bsdi) && !defined(__FreeBSD__) && !defined(__OpenBSD__)
+#if !defined(bsdi) && !defined(__FreeBSD__) && !defined(__OpenBSD__) && !defined(STDLIB_H_COVERS_MALLOC_H)
 #include <malloc.h>
 #endif
 
