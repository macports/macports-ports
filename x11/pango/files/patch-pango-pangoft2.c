--- pango/pangoft2.c.orig	Fri Aug  9 08:25:30 2002
+++ pango/pangoft2.c	Mon Apr 14 01:45:57 2003
@@ -696,7 +696,7 @@
   coverage = pango_coverage_new ();
   face = pango_ft2_font_get_face (font);
 
-#ifdef HAVE_FT_GET_FIRST_CHAR
+#if 0 /* #ifdef HAVE_FT_GET_FIRST_CHAR */
   {
     FT_UInt gindex;
     FT_ULong charcode;
