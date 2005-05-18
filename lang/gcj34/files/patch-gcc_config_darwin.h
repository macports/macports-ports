--- ../gcc/config/darwin.h.orig	2004-09-11 14:32:17.000000000 -0600
+++ ../gcc/config/darwin.h	2005-05-17 01:25:37.000000000 -0600
@@ -275,7 +275,7 @@
 /* Machine dependent libraries.  */
 
 #undef	LIB_SPEC
-#define LIB_SPEC "%{!static:-lSystem}"
+#define LIB_SPEC "%{!static: %{!mlong-double-64:%{pg:-lSystemStubs_profile;:-lSystemStubs}} -lmx -lSystem}"
 
 /* We specify crt0.o as -lcrt0.o so that ld will search the library path.  */
 
