--- Rendering/vtkAbstractMapper3D.cxx.orig	2005-06-19 17:22:26.000000000 -0400
+++ Rendering/vtkAbstractMapper3D.cxx	2005-06-19 17:25:32.000000000 -0400
@@ -20,18 +20,6 @@
 
 vtkCxxRevisionMacro(vtkAbstractMapper3D, "$Revision: 1.1 $");
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initRen() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
-
 // Construct with initial range (0,1).
 vtkAbstractMapper3D::vtkAbstractMapper3D()
 {
