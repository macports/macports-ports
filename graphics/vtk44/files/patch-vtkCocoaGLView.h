--- Rendering/vtkCocoaGLView.h.orig	2005-06-19 17:10:14.000000000 -0400
+++ Rendering/vtkCocoaGLView.h	2005-06-19 17:11:44.000000000 -0400
@@ -8,7 +8,7 @@
 
 @interface vtkCocoaGLView : NSOpenGLView
 {
-    enum NSOpenGLPixelFormatAttribute bitsPerPixel, depthSize;
+    NSOpenGLPixelFormatAttribute bitsPerPixel, depthSize;
 
     @private
     vtkCocoaRenderWindow *myVTKRenderWindow;
