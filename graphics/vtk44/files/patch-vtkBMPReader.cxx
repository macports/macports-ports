--- ./IO/vtkBMPReader.cxx.orig	2007-11-11 15:54:16.000000000 -0500
+++ ./IO/vtkBMPReader.cxx	2007-11-11 15:58:52.000000000 -0500
@@ -27,17 +27,6 @@
 #undef read
 #endif
 
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
-extern "C"
-{
-  void oft_initIO() 
-  {
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-  }
-}
-#endif
 
 vtkBMPReader::vtkBMPReader()
 {
