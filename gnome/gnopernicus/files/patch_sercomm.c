--- braille/libbrl/sercomm.c.org	Mon Sep 27 16:45:19 2004
+++ braille/libbrl/sercomm.c	Mon Sep 27 16:45:54 2004
@@ -118,6 +118,11 @@
 #if defined(OLCUC)
 	options.c_oflag &= ~OLCUC;
 #endif
+
+#if defined(__APPLE__)
+#define OCRNL 0x000000000
+#endif
+
     options.c_oflag &= ~ONLCR;
     options.c_oflag &= ~OCRNL;
 
