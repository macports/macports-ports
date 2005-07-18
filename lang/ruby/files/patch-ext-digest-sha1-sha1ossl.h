--- ext/digest/sha1/sha1ossl.h	2002-09-26 19:44:33.000000000 +0200
+++ etc/digest/sha1/sha1ossl.h	2005-07-18 22:09:59.000000000 +0200
@@ -3,6 +3,10 @@
 #ifndef SHA1OSSL_H_INCLUDED
 #define SHA1OSSL_H_INCLUDED
 
+#ifndef DARWINPORTS_SYSTYPES
+#define DARWINPORTS_SYSTYPES
+#include <sys/types.h>
+#endif
 #include <openssl/sha.h>
 
 #define SHA1_CTX	SHA_CTX
