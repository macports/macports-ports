--- src/libnrtype/nr-type-ft2.cpp.org	Wed Feb  4 16:30:22 2004
+++ src/libnrtype/nr-type-ft2.cpp	Thu Feb 12 00:02:18 2004
@@ -430,7 +430,7 @@
 		}
 		slot = tff->slots + tff->slots_length;
 
-		FT_Load_Glyph (tff->ft_face, glyph, FT_LOAD_NO_SCALE | FT_LOAD_NO_HINTING | FT_LOAD_NO_BITMAP);
+		if (FT_Load_Glyph (tff->ft_face, glyph, FT_LOAD_NO_SCALE | FT_LOAD_NO_HINTING | FT_LOAD_NO_BITMAP)) return NULL;
 
 		slot->area.x0 = tff->ft_face->glyph->metrics.horiBearingX * tff->ft2ps;
 		slot->area.y1 = tff->ft_face->glyph->metrics.horiBearingY * tff->ft2ps;
