--- src/bswap.h.orig	Tue Apr 29 13:31:35 2003
+++ src/bswap.h	Sat May  8 01:19:22 2004
@@ -59,6 +59,12 @@
 #define B2N_32(x) x = be32toh(x)
 #define B2N_64(x) x = be64toh(x)
 
+#elif defined(__DARWIN__)
+#include <limits.h>
+#define B2N_16(x) NXSwapShort(x)
+#define B2N_32(x) NXSwapInt(x)
+#define B2N_64(x) NXSwapLongLong(x)
+
 /* This is a slow but portable implementation, it has multiple evaluation 
  * problems so beware.
  * Old FreeBSD's and Solaris don't have <byteswap.h> or any other such 
