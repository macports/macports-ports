--- pango/pango-ot.h.old	Sun Mar  7 21:39:29 2004
+++ pango/pango-ot.h	Sun Mar  7 21:39:50 2004
@@ -22,7 +22,8 @@
 #ifndef __PANGO_OT_H__
 #define __PANGO_OT_H__
 
-#include <freetype/freetype.h>
+#include <ft2build.h>
+#include FT_FREETYPE_H
 #include <pango/pango-glyph.h>
 
 G_BEGIN_DECLS
