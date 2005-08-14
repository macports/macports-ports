--- Common/vtkAbstractMapper.cxx.orig	2005-06-19 11:09:24.000000000 -0400
+++ Common/vtkAbstractMapper.cxx	2005-06-19 11:09:40.000000000 -0400
@@ -29,16 +29,6 @@
 
 vtkCxxSetObjectMacro(vtkAbstractMapper,ClippingPlanes,vtkPlaneCollection);
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{void oft_initCom() 
- {
-   extern void _ZNSt8ios_base4InitC4Ev();
-   _ZNSt8ios_base4InitC4Ev();
- }
-}
-#endif
 
 // Construct object.
 vtkAbstractMapper::vtkAbstractMapper()
