--- python/vtemodule.c.orig	Mon Apr 19 23:22:54 2004
+++ python/vtemodule.c	Sat Oct 16 18:21:57 2004
@@ -22,6 +22,7 @@
 #include "../config.h"
 #endif
 #include <Python.h>
+#define NO_IMPORT_PYGTK
 #include <pygobject.h>
 #include <pygtk/pygtk.h>
 #include "../src/vte.h"
