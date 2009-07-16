--- src/common/pa_types.h.orig	2009-07-16 12:37:32.000000000 -0700
+++ src/common/pa_types.h	2009-07-16 12:37:50.000000000 -0700
@@ -62,7 +62,11 @@
 #endif
 
 #ifndef SIZEOF_LONG
+#ifdef __LP64__
+#define SIZEOF_LONG 8
+#else
 #define SIZEOF_LONG 4
+#endif /* __LP64__ */
 #endif
 
 
