--- Rendering/vtkCocoaGLView.mm.orig	2005-08-02 19:56:48.000000000 -0400
+++ Rendering/vtkCocoaGLView.mm	2005-08-02 19:59:15.000000000 -0400
@@ -9,7 +9,7 @@
 - (void)awakeFromNib
 {
     // Initialization
-    bitsPerPixel = depthSize = (enum NSOpenGLPixelFormatAttribute)32;
+    bitsPerPixel = depthSize = (NSOpenGLPixelFormatAttribute)32;
 }
 
 - (id)initWithFrame:(NSRect)theFrame
@@ -20,8 +20,8 @@
         NSOpenGLPFAAccelerated,
         NSOpenGLPFANoRecovery,
         NSOpenGLPFADoubleBuffer,
-        NSOpenGLPFADepthSize, (enum NSOpenGLPixelFormatAttribute)32,
-        (enum NSOpenGLPixelFormatAttribute)nil};
+        NSOpenGLPFADepthSize, (NSOpenGLPixelFormatAttribute)32,
+        (NSOpenGLPixelFormatAttribute)nil};
         
   NSOpenGLPixelFormat *fmt;
 
