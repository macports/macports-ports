--- rbogl.c	Sat Aug 16 23:46:15 2003
+++ ../opengl-0.32c-patched/rbogl.c	Tue Jan 27 22:21:33 2004
@@ -6,7 +6,11 @@
 # include "windows.h"
 #endif
 #include "rbogl.h"
-#include "GL/gl.h"
+#ifdef __APPLE__
+    #include <OpenGL/gl.h>
+#else
+    #include "GL/gl.h"
+#endif
 
 #ifdef _NO_NUM2DBL_
 extern double
