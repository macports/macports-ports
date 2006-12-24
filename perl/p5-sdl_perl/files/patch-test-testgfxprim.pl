--- test/testgfxprim.pl.orig	2006-11-27 06:03:08.000000000 -0800
+++ test/testgfxprim.pl	2006-11-27 06:03:24.000000000 -0800
@@ -202,10 +202,10 @@
 		$surfMidWidth*.25,$surfMidHeight*.10,255,255,0,255);
 
 	# pie slices
-	SDL::GFXFilledpieRGBA($surf,$surfMidWidth,$surfMidHeight, $surfMidWidth*.1,
+	SDL::GFXFilledPieRGBA($surf,$surfMidWidth,$surfMidHeight, $surfMidWidth*.1,
 		0,90,0,0,255,255);
 
-	SDL::GFXFilledpieRGBA($surf,$surfMidWidth,$surfMidHeight, $surfMidWidth*.1,
+	SDL::GFXFilledPieRGBA($surf,$surfMidWidth,$surfMidHeight, $surfMidWidth*.1,
 		180,270,0,0,255,255);
 
 	# polygons
