--- pango/opentype/pango-ot-info.c.old	Sun Mar  7 19:21:21 2004
+++ pango/opentype/pango-ot-info.c	Sun Mar  7 19:21:32 2004
@@ -22,7 +22,7 @@
 #include "pango-ot-private.h"
 #include "fterrcompat.h"
 #include <freetype/internal/ftobjs.h>
-#include <freetype/ftmodule.h>
+#include FT_MODULE_H
 
 static void pango_ot_info_class_init (GObjectClass *object_class);
 static void pango_ot_info_finalize   (GObject *object);
