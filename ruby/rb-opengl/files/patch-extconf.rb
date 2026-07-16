--- extconf.rb	Sat Aug 16 23:04:32 2003
+++ ../opengl-0.32c-patched/extconf.rb	Tue Jan 27 22:25:34 2004
@@ -33,21 +31,13 @@
 else
   $CPPFLAGS += " -I."
 
-  idir, ldir = dir_config("x11", "/usr/X11R6")
-
-  have_library("Xi", "XAllowDeviceEvents")
-  have_library("Xext", "XMITMiscGetBugMode")
-  have_library("Xmu", "XmuAddCloseDisplayHook")
-  have_library("X11", "XOpenDisplay")
   gl_libname = "GL"
   glu_libname = "GLU"
   glut_libname = "glut"
 end
-dir_config("opengl", idir, ldir)
-dir_config("glut", idir, ldir)
 
 def have_ogl_library(lib, func = 'main')
-  have_library(lib, func) || have_library("Mesa"+lib, func)
+  true
 end
 
 $objs = ["glu.o", "ogl.o", "rbogl.o"]
@@ -63,12 +53,10 @@
 end
 
 $objs = ["glut.o"]
-if have_library(glut_libname)
-    create_makefile("glut")
-    File.rename("Makefile", "Makefile.glut")
-    modules = "glut.#{CONFIG['DLEXT']} " + modules
-    glut_flg = true
-end
+create_makefile("glut")
+File.rename("Makefile", "Makefile.glut")
+modules = "glut.#{CONFIG['DLEXT']} " + modules
+glut_flg = true
 
 open("Makefile", "w") {|f|
   v = $nmake ? '{$(srcdir)}' : ''
