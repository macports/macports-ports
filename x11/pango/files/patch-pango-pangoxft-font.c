--- pango/pangoxft-font.c.orig	Fri Aug  9 08:25:30 2002
+++ pango/pangoxft-font.c	Mon Apr 14 01:44:26 2003
@@ -544,7 +544,7 @@
   face = pango_xft_font_get_face (font);
 
   coverage = pango_coverage_new ();
-#ifdef HAVE_FT_GET_FIRST_CHAR
+#if 0 /* #ifdef HAVE_FT_GET_FIRST_CHAR */
   {
     FT_UInt gindex;
     FT_ULong charcode;
