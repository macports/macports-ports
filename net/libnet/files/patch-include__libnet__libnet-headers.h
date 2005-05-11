--- include/libnet/libnet-headers.h.orig	2005-04-03 08:08:11.000000000 -0400
+++ include/libnet/libnet-headers.h	2005-04-03 08:08:23.000000000 -0400
@@ -509,7 +509,7 @@
 };
 
 
-#if (__linux__)
+#if (__linux__) || defined(__APPLE__)
 /*
  *  Linux has a radically different IP options structure from BSD.
  */
