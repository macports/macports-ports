--- Headers/cairo/CairoFaceInfo.h.orig	2007-06-17 17:20:29.000000000 -0400
+++ Headers/cairo/CairoFaceInfo.h	2007-06-17 17:21:46.000000000 -0400
@@ -28,6 +28,9 @@
 #include <Foundation/Foundation.h>
 #include <ft2build.h>  
 #include FT_FREETYPE_H
+#ifdef MAC_OS_X_VERSION_MAX_ALLOWED
+#undef MAC_OS_X_VERSION_MAX_ALLOWED
+#endif
 #include <cairo-ft.h>
 
 @interface CairoFaceInfo : NSObject
