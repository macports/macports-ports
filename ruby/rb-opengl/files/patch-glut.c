--- glut.c	Mon Aug  4 12:04:29 2003
+++ ../opengl-0.32c-patched/glut.c	Tue Jan 27 22:23:15 2004
@@ -5,7 +5,11 @@
 #if defined(WIN32)
 # include "windows.h"
 #endif
-#include "GL/glut.h"
+#ifdef __APPLE__
+    #include <GLUT/glut.h>
+#else
+    #include "GL/glut.h"
+#endif
 #include "ruby.h"
 
 static int callId; /* 'call' method id */
