--- src/libnr/nr-pathops.c.org	Sun Mar 14 08:07:52 2004
+++ src/libnr/nr-pathops.c	Sun Mar 14 08:08:01 2004
@@ -20,7 +20,6 @@
 #define QROUND(v) (floor (QUANT * (v) + 0.5) / QUANT)
 
 #include <math.h>
-#include <malloc.h>
 #include <string.h>
 #include <assert.h>
 
