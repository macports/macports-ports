--- Rendering/vtkCocoaRenderWindow.mm.orig	2009-03-24 06:25:48.000000000 -0400
+++ Rendering/vtkCocoaRenderWindow.mm	2009-03-24 06:26:16.000000000 -0400
@@ -189,14 +189,14 @@
 
   // Obtain the OpenGL context in order to keep track of the current screen.
   NSOpenGLContext* context = [[(vtkCocoaWindow*)this->WindowId getvtkCocoaGLView] openGLContext];
-  int currentScreen = [context currentVirtualScreen];
+  GLint currentScreen = [context currentVirtualScreen];
 
   // The NSOpenGLPixelFormat can only be queried for one particular
   // attribute at a time. Just make repeated queries to get the
   // pertinent settings.
   NSOpenGLPixelFormat* pixelFormat = [[(vtkCocoaWindow*)this->WindowId getvtkCocoaGLView] pixelFormat];
   strm << "PixelFormat Descriptor:" << endl;
-  long pfd;
+  GLint pfd;
   [pixelFormat getValues: &pfd forAttribute: NSOpenGLPFAColorSize forVirtualScreen: currentScreen];
   strm  << "  colorSize:  " << pfd << endl;
 
@@ -240,7 +240,7 @@
   int currentScreen = [context currentVirtualScreen];
 
   NSOpenGLPixelFormat* pixelFormat = [[(vtkCocoaWindow*)this->WindowId getvtkCocoaGLView] pixelFormat];
-  long pfd;
+  GLint pfd;
   [pixelFormat getValues: &pfd forAttribute: NSOpenGLPFACompliant forVirtualScreen: currentScreen];
 
   return (pfd == YES ? 1 : 0);
@@ -258,7 +258,7 @@
   int currentScreen = [context currentVirtualScreen];
 
   NSOpenGLPixelFormat* pixelFormat = [[(vtkCocoaWindow*)this->WindowId getvtkCocoaGLView] pixelFormat];
-  long pfd;
+  GLint pfd;
   [pixelFormat getValues: &pfd forAttribute: NSOpenGLPFAFullScreen forVirtualScreen: currentScreen];
 
   return (pfd == YES ? 1 : 0);
