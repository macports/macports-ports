--- ft.c.orig	2004-01-01 08:30:50.000000000 +1100
+++ ft.c	2014-10-10 06:38:57.000000000 +1100
@@ -12,11 +12,12 @@
 #include <stdlib.h>
 #include <ctype.h>
 #include <sys/types.h>
-#include <freetype/freetype.h>
-#include <freetype/ftglyph.h>
-#include <freetype/ftsnames.h>
-#include <freetype/ttnameid.h>
-#include <freetype/ftoutln.h>
+#include <ft2build.h>
+#include FT_FREETYPE_H
+#include FT_GLYPH_H
+#include FT_SFNT_NAMES_H
+#include FT_TRUETYPE_IDS_H
+#include FT_OUTLINE_H
 #include "pt1.h"
 #include "global.h"
 
