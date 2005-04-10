--- splash/SplashFTFontEngine.h.orig	Sun Apr 10 09:45:23 2005
+++ splash/SplashFTFontEngine.h	Sun Apr 10 09:45:48 2005
@@ -14,7 +14,7 @@
 #ifdef USE_GCC_PRAGMAS
 #pragma interface
 #endif
-
+#include <ft2build.h>
 #include <freetype/freetype.h>
 #include "gtypes.h"
 
