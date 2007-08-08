--- lib/gif_lib.h	2005-10-10 08:08:49.000000000 +0200
+++ lib/gif_lib.h	2007-08-08 14:07:18.000000000 +0200
@@ -266,7 +266,7 @@
 
 extern ColorMapObject *MakeMapObject(int ColorCount,
                                      const GifColorType * ColorMap);
-extern void FreeMapObject(ColorMapObject * Object);
+extern void FreeMapObject(ColorMapObject *ColorMapObject);
 extern ColorMapObject *UnionColorMap(const ColorMapObject * ColorIn1,
                                      const ColorMapObject * ColorIn2,
                                      GifPixelType ColorTransIn2[]);
