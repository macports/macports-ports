--- gdft.c.orig	Tue Mar 30 11:12:48 2004
+++ gdft.c	Tue Mar 30 11:14:59 2004
@@ -54,8 +54,9 @@
 #else
 
 #include "gdcache.h"
-#include "freetype/freetype.h"
-#include "freetype/ftglyph.h"
+#include <ft2build.h>
+#include FT_FREETYPE_H
+#include FT_GLYPH_H
 
 /* number of fonts cached before least recently used is replaced */
 #define FONTCACHESIZE 6
