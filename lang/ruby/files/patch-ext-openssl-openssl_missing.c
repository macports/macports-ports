--- ext/openssl/openssl_missing.c	2004-07-01 05:01:07.000000000 +0200
+++ etc/openssl/openssl_missing.c	2005-07-18 22:06:12.000000000 +0200
@@ -11,6 +11,10 @@
 
 #if !defined(OPENSSL_NO_HMAC)
 #include <string.h> /* memcpy() */
+#ifndef DARWINPORTS_SYSTYPES
+#define DARWINPORTS_SYSTYPES
+#include <sys/types.h>
+#endif
 #include <openssl/hmac.h>
 
 #if !defined(HAVE_HMAC_CTX_COPY)
@@ -30,6 +34,10 @@
 #endif /* NO_HMAC */
 
 #if !defined(HAVE_X509_STORE_SET_EX_DATA)
+#ifndef DARWINPORTS_SYSTYPES
+#define DARWINPORTS_SYSTYPES
+#include <sys/types.h>
+#endif
 #include <openssl/x509_vfy.h>
 
 int X509_STORE_set_ex_data(X509_STORE *str, int idx, void *data)
