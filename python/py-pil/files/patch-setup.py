--- setup.py	2005-03-23 19:16:40.000000000 +0100
+++ setup.py	2005-07-11 18:50:55.000000000 +0200
@@ -28,11 +28,11 @@
 #
 # TIFF_ROOT = libinclude("/opt/tiff")
 
-FREETYPE_ROOT = None
-JPEG_ROOT = None
-TIFF_ROOT = None
-ZLIB_ROOT = None
-TCL_ROOT = None
+FREETYPE_ROOT = "__PREFIX__/lib/", "__PREFIX__/include/freetype2/"
+JPEG_ROOT = "__PREFIX__/lib", "__PREFIX__/include"
+TIFF_ROOT = "__PREFIX__/lib", "__PREFIX__/include"
+ZLIB_ROOT = "__PREFIX__/lib", "__PREFIX__/include"
+TCL_ROOT = "__PREFIX__/lib", "__PREFIX__/include"
 
 # FIXME: add mechanism to explicitly *disable* the use of a library
 
