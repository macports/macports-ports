--- Graphics/vtkAppendFilter.cxx.orig	2005-06-19 11:48:14.000000000 -0400
+++ Graphics/vtkAppendFilter.cxx	2005-06-19 11:48:30.000000000 -0400
@@ -28,18 +28,6 @@
 vtkCxxRevisionMacro(vtkAppendFilter, "$Revision: 1.1 $");
 vtkStandardNewMacro(vtkAppendFilter);
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initGra() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
-
 //----------------------------------------------------------------------------
 vtkAppendFilter::vtkAppendFilter()
 {
