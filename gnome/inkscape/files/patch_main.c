--- src/main.c.org	Mon Jan 19 16:34:47 2004
+++ src/main.c	Mon Jan 19 16:42:22 2004
@@ -24,6 +24,10 @@
 
 #include <config.h>
 
+#ifdef __APPLE__
+    #undef HAVE_FPSETMASK
+#endif
+
 #ifdef HAVE_FPSETMASK
 #include <ieeefp.h>
 #endif
