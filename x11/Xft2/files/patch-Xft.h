--- Xft.h.old	Thu Mar  4 14:43:08 2004
+++ Xft.h	Thu Mar  4 14:43:23 2004
@@ -38,7 +38,8 @@
 #define XftVersion	XFT_VERSION
 
 #include <stdarg.h>
-#include <freetype/freetype.h>
+#include <ft2build.h>
+#include FT_FREETYPE_H
 #include <fontconfig/fontconfig.h>
 #include <X11/extensions/Xrender.h>
 
