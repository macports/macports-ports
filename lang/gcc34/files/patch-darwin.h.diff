--- gcc/config/darwin.h.sav	2005-05-18 13:56:37.000000000 -0400
+++ gcc/config/darwin.h		2004-05-18 13:57:48.000000000 -0400
@@ -275,7 +275,8 @@
 /* Machine dependent libraries.  */
 
 #undef	LIB_SPEC
-#define LIB_SPEC "%{!static:-lSystem}"
+#define LIB_SPEC "%{!static:-lSystemStubs -lSystem}"
+
 
 /* We specify crt0.o as -lcrt0.o so that ld will search the library path.  */
 
