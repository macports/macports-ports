--- finch/libgnt/gntwm.c.orig	2012-06-30 18:54:47.000000000 -0500
+++ finch/libgnt/gntwm.c	2012-07-25 14:34:58.000000000 -0500
@@ -22,6 +22,8 @@
 
 #include "config.h"
 
+#define NO_WIDECHAR
+
 #ifdef USE_PYTHON
 #include <Python.h>
 #endif
