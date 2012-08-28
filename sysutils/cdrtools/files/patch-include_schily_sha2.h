--- include/schily/sha2.h.orig	2009-08-09 14:29:59.000000000 +0200
+++ include/schily/sha2.h	2012-08-28 10:32:52.000000000 +0200
@@ -102,9 +102,11 @@
 
 #ifdef	HAVE_LONGLONG
 extern void SHA384Init		__PR((SHA2_CTX *));
+#ifndef HAVE_PRAGMA_WEAK
 extern void SHA384Transform	__PR((UInt64_t state[8], const UInt8_t [SHA384_BLOCK_LENGTH]));
 extern void SHA384Update	__PR((SHA2_CTX *, const UInt8_t *, size_t));
 extern void SHA384Pad		__PR((SHA2_CTX *));
+#endif
 extern void SHA384Final		__PR((UInt8_t [SHA384_DIGEST_LENGTH], SHA2_CTX *));
 extern char *SHA384End		__PR((SHA2_CTX *, char *));
 extern char *SHA384File		__PR((const char *, char *));
