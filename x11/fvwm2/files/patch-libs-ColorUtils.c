--- libs/ColorUtils.c.orig	Sat Mar 10 18:48:39 2001
+++ libs/ColorUtils.c	Sat Feb  7 12:56:03 2004
@@ -59,8 +59,8 @@
 /* From Xm.h on Solaris */
 #define XmDEFAULT_DARK_THRESHOLD        15
 #define XmDEFAULT_LIGHT_THRESHOLD       85
-extern Colormap Pcmap;
-extern Display *Pdpy;
+
+#include "libs/Picture.h"
 
 static XColor color;
 
