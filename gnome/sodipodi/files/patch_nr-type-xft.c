--- src/libnrtype/nr-type-xft.c.org	Mon Jan 19 15:59:50 2004
+++ src/libnrtype/nr-type-xft.c	Mon Jan 19 16:00:34 2004
@@ -171,14 +171,8 @@
 			/* fixme: This is silly and evil */
 			/* But Freetype just does not load pfa reliably (Lauris) */
 			if ((len > 4) &&
-			    (!strcmp (file + len - 4, ".ttf") ||
-			     !strcmp (file + len - 4, ".TTF") ||
-			     !strcmp (file + len - 4, ".ttc") ||
-			     !strcmp (file + len - 4, ".TTC") ||
-			     !strcmp (file + len - 4, ".otf") ||
-			     !strcmp (file + len - 4, ".OTF") ||
-			     !strcmp (file + len - 4, ".pfb") ||
-			     !strcmp (file + len - 4, ".PFB"))) {
+			strcmp (file + len - 4, ".pfa") &&
+                          strcmp (file + len - 4, ".PFA")) {
 				char *fn, *wn, *sn, *name;
 				int weight;
 				int slant;
