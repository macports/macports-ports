--- src/opengl/openglgraphics.cpp       2006-06-30 14:42:58.000000000 +0300
+++ src/opengl/openglgraphics.cpp       2006-06-30 11:15:35.000000000 +0300
@@ -64,6 +64,8 @@
 #ifdef __amigaos4__
 #include <mgl/gl.h>
 #define glVertex3i glVertex3f
+#elif (defined __APPLE__ && defined __MACH__)
+#include <OpenGL/gl.h>
 #else
 #include <GL/gl.h>
 #endif
