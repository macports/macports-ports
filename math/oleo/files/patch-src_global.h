--- src/global.h.orig	Wed Feb 14 13:54:50 2001
+++ src/global.h	Thu Feb 19 16:26:01 2004
@@ -208,7 +208,7 @@
 extern char nname[];
 
 extern VOIDSTAR parse_hash;
-extern double __plinf, __neinf, __nan;
+extern double __plinf, __neinf, __o_nan;
 
 /* These have two uses.  During parsing, these contain the 
  * base address of all relative references.  During evaluation,
