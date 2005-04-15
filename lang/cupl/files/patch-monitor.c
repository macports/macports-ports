--- monitor.c.orig	2005-04-15 01:50:18.000000000 -0400
+++ monitor.c	2005-04-15 01:50:29.000000000 -0400
@@ -63,6 +63,7 @@
 #include <stdlib.h>
 #include <stdarg.h>
 #include <math.h>
+#include <string.h>
 #include "cupl.h"
 
 #define max(x, y)	((x) > (y) ? (x) : (y))
