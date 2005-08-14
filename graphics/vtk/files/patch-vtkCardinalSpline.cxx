--- Filtering/vtkCardinalSpline.cxx.orig	2005-06-19 11:22:35.000000000 -0400
+++ Filtering/vtkCardinalSpline.cxx	2005-06-19 11:22:54.000000000 -0400
@@ -23,18 +23,6 @@
 vtkCxxRevisionMacro(vtkCardinalSpline, "$Revision: 1.1 $");
 vtkStandardNewMacro(vtkCardinalSpline);
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initFil() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
-
 
 // Construct a Cardinal Spline.
 vtkCardinalSpline::vtkCardinalSpline ()
