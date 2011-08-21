--- image/png.c.orig	2001-04-11 18:37:00.000000000 +1000
+++ image/png.c	2011-08-21 10:56:49.000000000 +1000
@@ -134,7 +134,7 @@ pngLoad(fullname, name, verbose)
 	} 
 
 	if (colortype == PNG_COLOR_TYPE_GRAY && bitdepth < 8){
-		png_set_gray_1_2_4_to_8(png_ptr);
+		png_set_expand_gray_1_2_4_to_8(png_ptr);
 	}
 
 	if (png_get_valid(png_ptr, info_ptr, PNG_INFO_tRNS)){
