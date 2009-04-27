--- ./Graphics/vtkAppendFilter.cxx.orig	2007-11-11 15:53:32.000000000 -0500
+++ ./Graphics/vtkAppendFilter.cxx	2007-11-11 15:58:44.000000000 -0500
@@ -25,17 +25,6 @@
 vtkCxxRevisionMacro(vtkAppendFilter, "$Revision: 1.64 $");
 vtkStandardNewMacro(vtkAppendFilter);
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initGraphics() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
 
 //----------------------------------------------------------------------------
 vtkAppendFilter::vtkAppendFilter()
