--- Rendering/vtkTkWidgetsInit.cxx.orig	2006-02-12 20:38:50.000000000 -0600
+++ Rendering/vtkTkWidgetsInit.cxx	2006-02-12 20:39:15.000000000 -0600
@@ -24,7 +24,7 @@
 
 
 //-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#ifdef __APPLE_CC__
+#if defined(__APPLE_CC__) && (__GNUC__ == 3)
 extern "C"
 {
   void oft_initRenWidgets()
