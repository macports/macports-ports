--- finch/libgnt/gntwm.c.old	2009-12-20 09:43:59.000000000 -0800
+++ finch/libgnt/gntwm.c	2009-12-20 09:44:24.000000000 -0800
@@ -22,6 +22,8 @@
 
 #include "config.h"
 
+#define NO_WIDECHAR
+
 #ifdef USE_PYTHON
 #include <Python.h>
 #else
