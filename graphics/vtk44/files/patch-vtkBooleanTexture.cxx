--- ./Imaging/vtkBooleanTexture.cxx.orig	2007-11-11 15:54:51.000000000 -0500
+++ ./Imaging/vtkBooleanTexture.cxx	2007-11-11 15:58:56.000000000 -0500
@@ -22,17 +22,6 @@
 vtkCxxRevisionMacro(vtkBooleanTexture, "$Revision: 1.37 $");
 vtkStandardNewMacro(vtkBooleanTexture);
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initImaging() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
 
 vtkBooleanTexture::vtkBooleanTexture()
 {
