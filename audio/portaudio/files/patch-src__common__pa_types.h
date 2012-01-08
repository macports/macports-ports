--- src/common/pa_types.h.orig	2006-08-26 17:27:53.000000000 +0900
+++ src/common/pa_types.h	2012-01-07 20:26:17.000000000 +0900
@@ -62,7 +62,11 @@
 #endif
 
 #ifndef SIZEOF_LONG
+#ifdef __LP64__
+#define SIZEOF_LONG 8
+#else
 #define SIZEOF_LONG 4
+#endif /* __LP64__ */
 #endif
 
 
