--- ./Hybrid/vtk3DSImporter.cxx.orig	2007-11-11 15:54:01.000000000 -0500
+++ ./Hybrid/vtk3DSImporter.cxx	2007-11-11 15:58:48.000000000 -0500
@@ -30,17 +30,6 @@
 vtkCxxRevisionMacro(vtk3DSImporter, "$Revision: 1.36 $");
 vtkStandardNewMacro(vtk3DSImporter);
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initHybrid() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
 
 
 static vtk3DSColour Black = {0.0, 0.0, 0.0};
