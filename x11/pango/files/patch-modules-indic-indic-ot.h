--- modules/indic/indic-ot.h.old	Sun Mar  7 22:02:28 2004
+++ modules/indic/indic-ot.h	Sun Mar  7 22:02:45 2004
@@ -9,7 +9,8 @@
 #ifndef __INDIC_OT_H__
 #define __INDIC_OT_H__
 
-#include <freetype/freetype.h>
+#include <ft2build.h>
+#include FT_FREETYPE_H
 #include <pango/pango-glyph.h>
 #include <pango/pango-types.h>
 #include "mprefixups.h"
