--- pango/pangoft2.c.old	Sun Mar  7 21:46:00 2004
+++ pango/pangoft2.c	Sun Mar  7 21:46:21 2004
@@ -28,7 +28,8 @@
 #include <glib.h>
 #include <glib/gprintf.h>
 
-#include <freetype/freetype.h>
+#include <ft2build.h>
+#include FT_FREETYPE_H
 
 #include "pango-utils.h"
 #include "pangoft2.h"
