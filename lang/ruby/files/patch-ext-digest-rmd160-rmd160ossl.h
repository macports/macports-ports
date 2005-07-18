--- ext/digest/rmd160/rmd160ossl.h	2002-09-26 19:26:46.000000000 +0200
+++ etc/digest/rmd160/rmd160ossl.h	2005-07-18 22:09:06.000000000 +0200
@@ -3,6 +3,10 @@
 #ifndef RMD160OSSL_H_INCLUDED
 #define RMD160OSSL_H_INCLUDED
 
+#ifndef DARWINPORTS_SYSTYPES
+#define DARWINPORTS_SYSTYPES
+#include <sys/types.h>
+#endif
 #include <openssl/ripemd.h>
 
 #define RMD160_CTX	RIPEMD160_CTX
