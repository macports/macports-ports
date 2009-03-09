--- ./Rendering/vtkTkWidgetsInit.cxx.orig	2007-11-11 15:56:48.000000000 -0500
+++ ./Rendering/vtkTkWidgetsInit.cxx	2007-11-11 15:59:34.000000000 -0500
@@ -20,17 +20,6 @@
 #include "vtkImageData.h"
 
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initRenderingWidgets()
-  {
-    extern void _ZNSt8ios_base4InitC4Ev();
-    _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
 
 
 //----------------------------------------------------------------------------
