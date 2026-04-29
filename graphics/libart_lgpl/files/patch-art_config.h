--- art_config.h.orig	2009-06-11 11:47:41.000000000 -0700
+++ art_config.h	2009-06-11 11:48:01.000000000 -0700
@@ -3,7 +3,11 @@
 #define ART_SIZEOF_CHAR 1
 #define ART_SIZEOF_SHORT 2
 #define ART_SIZEOF_INT 4
+#ifdef __LP64__
+#define ART_SIZEOF_LONG 8
+#else
 #define ART_SIZEOF_LONG 4
+#endif
 
 typedef unsigned char art_u8;
 typedef unsigned short art_u16;
