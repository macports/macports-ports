--- lib/glut/glutbitmap.h.orig
+++ lib/glut/glutbitmap.h
@@ -7,7 +7,7 @@
    and is provided without guarantee or warrantee expressed or 
    implied. This program is -not- in the public domain. */
 
-#include <GL/glut.h>
+#include "glut.h"
 
 typedef struct {
   const GLsizei width;

--- lib/glut/glutint.h.orig
+++ lib/glut/glutint.h
@@ -22,7 +22,7 @@
 #include <GL/glx.h>
 #endif
 
-#include <GL/glut.h>
+#include "glut.h"
 
 /* Non-Win32 platforms need APIENTRY defined to nothing
    because all the GLUT routines have the APIENTRY prefix
