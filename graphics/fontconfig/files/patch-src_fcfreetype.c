--- src/fcfreetype.c.old	Mon Mar  1 06:18:32 2004
+++ src/fcfreetype.c	Mon Mar  1 06:18:47 2004
@@ -57,7 +57,7 @@
 
 #if (FREETYPE_MINOR > 1 || (FREETYPE_MINOR == 1 && FREETYPE_PATCH >= 4))
 #include <freetype/ftbdf.h>
-#include <freetype/ftmodule.h>
+#include FT_MODULE_H
 #define USE_FTBDF
 #define HAS_BDF_PROPERTY(f) ((f) && (f)->driver && \
 			     (f)->driver->root.clazz->get_interface)
