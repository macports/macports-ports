--- bytesex.h.orig	2009-08-30 10:11:15.000000000 -0700
+++ bytesex.h	2009-08-30 10:11:27.000000000 -0700
@@ -7,7 +7,7 @@
 #ifndef ARS_BYTESEX_H
 #define ARS_BYTESEX_H
 
-#if 	defined(__i386__) \
+#if 	defined(__i386__) || defined(__x86_64__) \
 	|| defined(__alpha__) \
 	|| (defined(__mips__) && (defined(MIPSEL) || defined (__MIPSEL__)))
 #define BYTE_ORDER_LITTLE_ENDIAN
