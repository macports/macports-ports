--- Rendering/vtkOSXRenderingTclInit.c.orig	2006-02-12 20:38:43.000000000 -0600
+++ Rendering/vtkOSXRenderingTclInit.c	2006-02-12 20:40:22.000000000 -0600
@@ -1,8 +1,10 @@
 //-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
+#if defined(__APPLE_CC__) && (__GNUC__ == 3)
 #include <stdio.h>
 void oft_initRenOSXInit() 
 {
   extern void _ZNSt8ios_base4InitC4Ev();
   _ZNSt8ios_base4InitC4Ev();
 }
+#endif
 
