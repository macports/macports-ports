--- lib/GL/apple/dri_driver.h.orig	2005-10-14 11:15:55.000000000 -0400
+++ lib/GL/apple/dri_driver.h	2007-03-31 12:52:24.000000000 -0400
@@ -36,6 +36,8 @@
 #ifndef _DRI_DRIVER_H_
 #define _DRI_DRIVER_H_
 
+typedef char GLchar;
+
 #include "Xplugin.h"
 #include <X11/Xthreads.h>
 #include <CoreGraphics/CoreGraphics.h>
