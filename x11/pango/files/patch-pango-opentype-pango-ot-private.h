--- pango/opentype/pango-ot-private.h.old	Sun Mar  7 19:15:30 2004
+++ pango/opentype/pango-ot-private.h	Sun Mar  7 19:15:56 2004
@@ -22,7 +22,8 @@
 #ifndef __PANGO_OT_PRIVATE_H__
 #define __PANGO_OT_PRIVATE_H__
 
-#include <freetype/freetype.h>
+#include <ft2build.h>
+#include FT_FREETYPE_H
 
 #include <glib-object.h>
 
