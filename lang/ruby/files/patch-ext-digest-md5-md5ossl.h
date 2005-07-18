--- ext/digest/md5/md5ossl.h	2002-09-26 18:27:23.000000000 +0200
+++ ext/digest/md5/md5ossl.h	2005-07-18 22:05:21.000000000 +0200
@@ -3,6 +3,10 @@
 #ifndef MD5OSSL_H_INCLUDED
 #define MD5OSSL_H_INCLUDED
 
+#ifndef DARWINPORTS_SYSTYPES
+#define DARWINPORTS_SYSTYPES
+#include <sys/types.h>
+#endif
 #include <openssl/md5.h>
 
 void MD5_End(MD5_CTX *pctx, unsigned char *hexdigest);
