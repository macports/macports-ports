--- src/opengl/openglimageloader.cpp	2006-06-30 14:46:14.000000000 +0300
+++ src/opengl/openglimageloader.cpp	2006-06-30 11:18:58.000000000 +0300
@@ -63,6 +63,8 @@
 
 #ifdef __amigaos4__
 #include <mgl/gl.h>
+#elif (defined __APPLE__ && defined __MACH__)
+#include <OpenGL/gl.h>
 #else
 #include <GL/gl.h>
 #endif
