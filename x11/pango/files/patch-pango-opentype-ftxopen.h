--- pango/opentype/ftxopen.h.old	Sun Mar  7 21:32:25 2004
+++ pango/opentype/ftxopen.h	Sun Mar  7 21:33:05 2004
@@ -22,7 +22,8 @@
 #ifndef FTXOPEN_H
 #define FTXOPEN_H
 
-#include <freetype/freetype.h>
+#include <ft2build.h>
+#include FT_FREETYPE_H
 
 #ifdef __cplusplus
 extern "C" {
