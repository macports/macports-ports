--- splash/SplashFTFontFile.h.orig	Sun Apr 10 09:41:13 2005
+++ splash/SplashFTFontFile.h	Sun Apr 10 09:41:55 2005
@@ -14,7 +14,7 @@
 #ifdef USE_GCC_PRAGMAS
 #pragma interface
 #endif
-
+#include <ft2build.h>
 #include <freetype/freetype.h>
 #include "SplashFontFile.h"
 
