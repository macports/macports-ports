--- fontconfig/fcfreetype.h.old	Mon Mar  1 06:13:54 2004
+++ fontconfig/fcfreetype.h	Mon Mar  1 06:14:19 2004
@@ -24,7 +24,8 @@
 
 #ifndef _FCFREETYPE_H_
 #define _FCFREETYPE_H_
-#include <freetype/freetype.h>
+#include <ft2build.h>
+#include FT_FREETYPE_H
 
 FT_UInt
 FcFreeTypeCharIndex (FT_Face face, FcChar32 ucs4);
