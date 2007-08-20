--- extras/freetype2/include/freetype/freetype.h.orig	2007-04-03 16:31:34.000000000 -0400
+++ extras/freetype2/include/freetype/freetype.h	2007-04-03 16:32:01.000000000 -0400
@@ -17,11 +17,7 @@
 
 
 #ifndef FT_FREETYPE_H
-#error "`ft2build.h' hasn't been included yet!"
-#error "Please always use macros to include FreeType header files."
-#error "Example:"
-#error "  #include <ft2build.h>"
-#error "  #include FT_FREETYPE_H"
+#include <ft2build.h>
 #endif
 
 
