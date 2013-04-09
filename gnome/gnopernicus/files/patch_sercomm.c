--- braille/libbrl/sercomm.c.orig	2006-05-08 03:01:52.000000000 -0700
+++ braille/libbrl/sercomm.c	2013-04-08 21:20:22.000000000 -0700
@@ -102,6 +102,11 @@
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
 
