--- src/common/xchat.h.orig	2005-09-28 00:17:08.000000000 -0700
+++ src/common/xchat.h	2005-09-28 00:17:15.000000000 -0700
@@ -52,13 +52,7 @@
 #endif
 
 /* force a 32bit CMP.L */
-#ifdef _MSC_VER
-#define CMPL(a, c0, c1, c2, c3) (*(guint32 *)(a) == (guint32)(c0 | (c1 << 8) | (c2 << 16) | (c3 << 24)))
-#else
 #define CMPL(a, c0, c1, c2, c3) (a == (guint32)(c0 | (c1 << 8) | (c2 << 16) | (c3 << 24)))
-#endif
-/* force a 16bit CMP.W */
-#define CMPW(a, c0, c1) (*(guint16 *)(a) == (guint16)(c0 | (c1 << 8)))
 #define WORDL(c0, c1, c2, c3) (guint32)(c0 | (c1 << 8) | (c2 << 16) | (c3 << 24))
 #define WORDW(c0, c1) (guint16)(c0 | (c1 << 8))
 
