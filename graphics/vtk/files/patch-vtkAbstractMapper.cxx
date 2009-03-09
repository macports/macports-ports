--- ./Common/vtkAbstractMapper.cxx.orig	2007-11-11 15:52:59.000000000 -0500
+++ ./Common/vtkAbstractMapper.cxx	2007-11-11 15:58:29.000000000 -0500
@@ -26,17 +26,6 @@
 
 vtkCxxSetObjectMacro(vtkAbstractMapper,ClippingPlanes,vtkPlaneCollection);
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{void oft_initCommon() 
- {
-   extern void _ZNSt8ios_base4InitC4Ev();
-   _ZNSt8ios_base4InitC4Ev();
- }
-}
-#endif
-
 // Construct object.
 vtkAbstractMapper::vtkAbstractMapper()
 {
