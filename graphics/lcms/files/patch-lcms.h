--- include/lcms.h.orig	Mon Sep 30 00:26:17 2002
+++ include/lcms.h	Mon Sep 30 00:08:15 2002
@@ -67,7 +67,7 @@
 
 // Uncomment this one if you are using big endian machines (only meaningfull
 // when NON_WINDOWS is used)
-// #define USE_BIG_ENDIAN   1
+#define USE_BIG_ENDIAN   1
 
 // Uncomment this one if your compiler/machine does support the
 // "long long" type This will speedup fixed point math. (USE_C only)
