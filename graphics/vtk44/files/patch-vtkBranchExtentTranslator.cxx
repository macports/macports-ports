--- ./Parallel/vtkBranchExtentTranslator.cxx.orig	2007-11-11 15:55:37.000000000 -0500
+++ ./Parallel/vtkBranchExtentTranslator.cxx	2007-11-11 15:58:59.000000000 -0500
@@ -23,17 +23,6 @@
 
 vtkCxxSetObjectMacro(vtkBranchExtentTranslator,OriginalSource,vtkImageData);
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initParallel() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
 
 
 //----------------------------------------------------------------------------
