--- pango/opentype/pango-ot-info.c.orig	Sun Jun 29 00:20:33 2003
+++ pango/opentype/pango-ot-info.c	Sun Jun 29 00:29:02 2003
@@ -216,6 +216,9 @@
   /* Collect all the glyphs in the charmap, and guess
    * the appropriate classes for them
    */
+/* Apple's X11 does not have FT_Get_First_Char() */
+#if 0  /* #ifdef HAVE_FT_GET_FIRST_CHAR */
+
   charcode = FT_Get_First_Char (info->face, &glyph);
   while (glyph != 0)
     {
@@ -231,6 +234,28 @@
       
       charcode = FT_Get_Next_Char (info->face, charcode, &glyph);
     }
+#else
+  {
+	  gunichar wc;
+
+	  for (wc = 0; wc < G_MAXUSHORT; wc++)
+	  {
+		  glyph = FT_Get_Char_Index (info->face, wc);
+
+		  if (glyph && glyph < info->face->num_glyphs) {
+			  GlyphInfo glyph_info;
+
+			  if (glyph > 65535)
+				  continue;
+
+			  glyph_info.glyph = glyph;
+			  glyph_info.class = get_glyph_class (charcode);
+
+			  g_array_append_val (glyph_infos, glyph_info);
+		  }
+	  }
+  }
+#endif
 
   /* Sort and remove duplicates
    */
