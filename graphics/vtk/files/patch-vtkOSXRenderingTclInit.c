--- ./Rendering/vtkOSXRenderingTclInit.c.orig	2007-11-11 15:56:34.000000000 -0500
+++ ./Rendering/vtkOSXRenderingTclInit.c	2007-11-11 15:59:28.000000000 -0500
@@ -1,8 +1 @@
-//-----  This hack needed to compile using gcc3 on OSX until new stdc++.dylib
-#include <stdio.h>
-void oft_initRenOSXInit() 
-{
-  extern void _ZNSt8ios_base4InitC4Ev();
-  _ZNSt8ios_base4InitC4Ev();
-}
 
