--- src/xrdb.c.orig	2000-08-10 15:02:51.000000000 -0600
+++ src/xrdb.c	2005-08-19 01:54:05.000000000 -0600
@@ -57,7 +57,6 @@
 /* This should be included before the X include files; otherwise, we get
    warnings about redefining NULL under BSD 4.3.  */
 #include <sys/param.h>
-#define NeedFunctionPrototypes 0
 #include <X11/X.h>
 #include <X11/Xlib.h>
 #include <X11/Xutil.h>
