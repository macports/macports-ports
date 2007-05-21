--- src/selblur.cpp.orig	2007-05-18 12:56:11.000000000 -0400
+++ src/selblur.cpp	2007-05-18 12:58:04.000000000 -0400
@@ -32,8 +32,8 @@
 // spec->dest[x + y * spec->dest_pitch32] = (r << spec->red_shift) | (g << spec->green_shift) | (b << spec->blue_shift);
 //}
 
-#define GetSourcePixel(_x, _y, _r, _g, _b) { uint32 __pixel = source[_x + _y * source_pitch32]; _r = (__pixel >> red_shift) & 0xFF; 	\
-	_g = (__pixel >> green_shift) & 0xFF; _b = (__pixel >> blue_shift) & 0xFF; }
+#define GetSourcePixel(_x, _y, _r, _g, _b) { uint32 __mypixel = source[_x + _y * source_pitch32]; _r = (__mypixel >> red_shift) & 0xFF; 	\
+	_g = (__mypixel >> green_shift) & 0xFF; _b = (__mypixel >> blue_shift) & 0xFF; }
 
 #define SetDestPixel(_x, _y, _r, _g, _b) dest[_x + _y * dest_pitch32] = (_r << red_shift) | (_g << green_shift) | (_b << blue_shift);
 
