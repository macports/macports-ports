--- Imaging/vtkBooleanTexture.cxx.orig	2005-06-19 11:34:38.000000000 -0400
+++ Imaging/vtkBooleanTexture.cxx	2005-06-19 11:34:51.000000000 -0400
@@ -25,18 +25,6 @@
 vtkCxxRevisionMacro(vtkBooleanTexture, "$Revision: 1.1 $");
 vtkStandardNewMacro(vtkBooleanTexture);
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initIma() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
-
 vtkBooleanTexture::vtkBooleanTexture()
 {
   this->Thickness = 0;
