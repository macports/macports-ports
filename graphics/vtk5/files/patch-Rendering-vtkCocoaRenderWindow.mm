--- Rendering/vtkCocoaRenderWindow.mm.orig	2007-11-10 20:48:38.000000000 -0800
+++ Rendering/vtkCocoaRenderWindow.mm	2007-11-10 20:54:33.000000000 -0800
@@ -220,7 +220,7 @@
   // pertinent settings.
   NSOpenGLPixelFormat* pixelFormat = (NSOpenGLPixelFormat*)this->PixelFormat;
   strm << "PixelFormat Descriptor:" << endl;
-  long pfd;
+  GLint pfd;
   [pixelFormat getValues: &pfd forAttribute: NSOpenGLPFAColorSize forVirtualScreen: currentScreen];
   strm  << "  colorSize:  " << pfd << endl;
 
@@ -265,7 +265,7 @@
   int currentScreen = [context currentVirtualScreen];
 
   NSOpenGLPixelFormat* pixelFormat = (NSOpenGLPixelFormat*)this->PixelFormat;
-  long pfd;
+  GLint pfd;
   [pixelFormat getValues: &pfd forAttribute: NSOpenGLPFACompliant forVirtualScreen: currentScreen];
 
   return (pfd == YES ? 1 : 0);
@@ -284,7 +284,7 @@
   int currentScreen = [context currentVirtualScreen];
 
   NSOpenGLPixelFormat* pixelFormat = (NSOpenGLPixelFormat*)this->PixelFormat;
-  long pfd;
+  GLint pfd;
   [pixelFormat getValues: &pfd forAttribute: NSOpenGLPFAFullScreen forVirtualScreen: currentScreen];
 
   return (pfd == YES ? 1 : 0);
