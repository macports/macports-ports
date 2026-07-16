--- writepng.c.orig	2009-06-13 06:58:50.000000000 +1000
+++ writepng.c	2012-10-20 22:16:09.000000000 +1100
@@ -240,6 +240,8 @@ void writepng(char *filename,
      double skewsin = sin(skew), skewcos = cos(skew);
      REAL minoverlay = 0, maxoverlay = 0;
      png_byte mask_byte;
+     png_colorp palette;
+
 
      /* we must use direct color for translucent overlays */
      if (overlay)
@@ -309,7 +311,7 @@ void writepng(char *filename,
      }
      /* Set error handling.  REQUIRED if you aren't supplying your own *
       * error hadnling functions in the png_create_write_struct() call. */
-     if (setjmp(png_ptr->jmpbuf)) {
+     if (setjmp(png_jmpbuf(png_ptr))) {
 	  /* If we get here, we had a problem reading the file */
 	  fclose(fp);
 	  png_destroy_write_struct(&png_ptr, (png_infopp) NULL);
@@ -334,8 +336,6 @@ void writepng(char *filename,
 		       PNG_INTERLACE_NONE,
 		       PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);
      else {
-	  png_colorp palette;
-
 	  png_set_IHDR(png_ptr, info_ptr, width, height, 8 /* bit_depth */ ,
 		       PNG_COLOR_TYPE_PALETTE,
 		       PNG_INTERLACE_NONE,
@@ -434,7 +434,8 @@ void writepng(char *filename,
      png_write_end(png_ptr, info_ptr);
 
      /* if you malloced the palette, free it here */
-     free(info_ptr->palette);
+     if (eight_bit)
+        png_free(png_ptr, palette);
 
      /* if you allocated any text comments, free them here */
 
