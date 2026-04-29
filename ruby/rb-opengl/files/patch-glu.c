--- glu.c	Mon Aug  4 12:05:48 2003
+++ ../opengl-0.32c-patched/glu.c	Tue Jan 27 22:22:50 2004
@@ -5,8 +5,13 @@
 #if defined(WIN32)
 # include "windows.h"
 #endif
-#include "GL/gl.h"
-#include "GL/glu.h"
+#ifdef __APPLE__
+    #include <OpenGL/gl.h>
+    #include <OpenGL/glu.h>
+#else
+    #include "GL/gl.h"
+    #include "GL/glu.h"
+#endif
 #include "rbogl.h"
 
 #ifdef WIN32
