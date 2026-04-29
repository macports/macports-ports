--- ogl.c	Sat Dec  1 00:28:29 2001
+++ ../opengl-0.32c-patched/ogl.c	Tue Jan 27 22:22:04 2004
@@ -5,7 +5,11 @@
 #if defined (WIN32)
 # include "windows.h"
 #endif
-#include "GL/gl.h"
+#ifdef __APPLE__
+    #include <OpenGL/gl.h>
+#else
+    #include "GL/gl.h"
+#endif
 #include "rbogl.h"
 
 #if defined __CYGWIN__
