--- Hybrid/vtk3DSImporter.cxx.orig	2006-02-12 20:33:47.000000000 -0600
+++ Hybrid/vtk3DSImporter.cxx	2006-02-12 20:36:02.000000000 -0600
@@ -34,7 +34,7 @@
 vtkStandardNewMacro(vtk3DSImporter);
 
 //-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
+#if defined(__APPLE_CC__) && (__GNUC__ == 3)
 extern "C"
 {
   void oft_initHyb() 
