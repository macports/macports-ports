--- programs/Xserver/hw/darwin/darwin.c.orig	2007-03-31 14:53:57.000000000 -0400
+++ programs/Xserver/hw/darwin/darwin.c	2007-03-31 14:54:35.000000000 -0400
@@ -118,6 +118,9 @@
 #ifndef PRE_RELEASE
 #define PRE_RELEASE XF86_VERSION_SNAP
 #endif
+#ifndef VENDOR_RELEASE
+#define VENDOR_RELEASE 6600
+#endif
 
 void
 DarwinPrintBanner()
