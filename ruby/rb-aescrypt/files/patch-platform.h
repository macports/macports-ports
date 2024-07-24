--- platform.h	2001-05-23 06:39:11
+++ platform.h	2024-03-09 12:53:53
@@ -49,7 +49,7 @@
 #endif
 #endif
 
-#if WORDS_BIGENDIAN
+#if WORDS_BIGENDIAN || defined(__POWERPC__)
 #define LittleEndian 0
 #define ALIGN32 1
 #else
