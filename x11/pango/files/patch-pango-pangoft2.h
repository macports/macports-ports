--- pango/pangoft2.h.old	Sun Mar  7 21:51:55 2004
+++ pango/pangoft2.h	Sun Mar  7 21:52:15 2004
@@ -23,7 +23,8 @@
 #ifndef __PANGOFT2_H__
 #define __PANGOFT2_H__
 
-#include <freetype/freetype.h>
+#include <ft2build.h>
+#include FT_FREETYPE_H
 
 #include <fontconfig/fontconfig.h>
 
