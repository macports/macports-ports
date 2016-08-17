--- src/SDL_Pango.c.orig	2014-07-27 23:46:29.000000000 +1000
+++ src/SDL_Pango.c	2014-07-27 23:47:57.000000000 +1000
@@ -330,6 +330,11 @@ SDLPango_WasInit()
     @param *rect [in] Draw on this area
     @param baseline [in] Horizontal location of glyphs
 */
+void SDLPango_CopyFTBitmapToSurface(
+    const FT_Bitmap *bitmap,
+    SDL_Surface *surface,
+    const SDLPango_Matrix *matrix,
+    SDL_Rect *rect);
 static void
 drawGlyphString(
     SDLPango_Context *context,
