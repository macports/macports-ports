--- Source/art/ftfont.m.orig	2007-04-29 13:50:37.000000000 -0400
+++ Source/art/ftfont.m	2007-04-29 13:50:46.000000000 -0400
@@ -31,6 +31,10 @@
 
 #else
 
+#ifdef	MAC_OS_X_VERSION_MAX_ALLOWED
+#undef	MAC_OS_X_VERSION_MAX_ALLOWED
+#endif
+

 #include <math.h>
 
