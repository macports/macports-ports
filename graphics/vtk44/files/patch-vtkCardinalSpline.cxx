--- ./Filtering/vtkCardinalSpline.cxx.orig	2007-11-11 15:53:15.000000000 -0500
+++ ./Filtering/vtkCardinalSpline.cxx	2007-11-11 15:58:40.000000000 -0500
@@ -20,17 +20,6 @@
 vtkCxxRevisionMacro(vtkCardinalSpline, "$Revision: 1.23 $");
 vtkStandardNewMacro(vtkCardinalSpline);
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initFiltering() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
 
 
 // Construct a Cardinal Spline.
