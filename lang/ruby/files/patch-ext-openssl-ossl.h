--- ext/openssl/ossl.h	2003-12-11 13:29:08.000000000 +0100
+++ etc/openssl/ossl.h	2005-07-18 22:07:48.000000000 +0200
@@ -20,6 +20,10 @@
  * The only supported are:
  * 	OpenSSL >= 0.9.7
  */
+#ifndef DARWINPORTS_SYSTYPES
+#define DARWINPORTS_SYSTYPES
+#include <sys/types.h>
+#endif
 #include <openssl/opensslv.h>
 
 #ifdef HAVE_ASSERT_H
