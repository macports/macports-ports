--- coders/dot.c.orig	2005-08-28 19:06:19.000000000 -0600
+++ coders/dot.c	2006-02-03 00:53:25.000000000 -0700
@@ -218,6 +218,6 @@
 {
   (void) UnregisterMagickInfo("DOT");
 #if defined(HasGVC)
-  gvCleanup(graphic_context);
+  gvFreeContext(graphic_context);
 #endif
 }
