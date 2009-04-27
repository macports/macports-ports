--- ./Patented/vtkDecimate.cxx.orig	2007-11-11 15:56:07.000000000 -0500
+++ ./Patented/vtkDecimate.cxx	2007-11-11 15:59:04.000000000 -0500
@@ -42,17 +42,6 @@
 vtkCxxRevisionMacro(vtkDecimate, "$Revision: 1.78 $");
 vtkStandardNewMacro(vtkDecimate);
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initPatented() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
 
 
 #define VTK_TOLERANCE 1.0e-05
