--- gtk/xdgmime/xdgmimecache.c.org	2005-04-15 18:03:46.000000000 +0200
+++ gtk/xdgmime/xdgmimecache.c	2005-04-15 18:06:31.000000000 +0200
@@ -49,6 +49,8 @@
 #include "xdgmimecache.h"
 #include "xdgmimeint.h"
 
+#include <stdint.h>
+
 #ifndef MAX
 #define MAX(a,b) ((a) > (b) ? (a) : (b))
 #endif
