--- ./Rendering/vtkAbstractMapper3D.cxx.orig	2007-11-11 15:56:25.000000000 -0500
+++ ./Rendering/vtkAbstractMapper3D.cxx	2007-11-11 15:59:09.000000000 -0500
@@ -18,17 +18,6 @@
 
 vtkCxxRevisionMacro(vtkAbstractMapper3D, "$Revision: 1.17 $");
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initRendering() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
 
 // Construct with initial range (0,1).
 vtkAbstractMapper3D::vtkAbstractMapper3D()
