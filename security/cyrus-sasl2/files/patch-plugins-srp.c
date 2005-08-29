--- plugins/srp.c.orig	2005-08-29 14:54:37.000000000 +0900
+++ plugins/srp.c	2005-08-29 14:54:42.000000000 +0900
@@ -87,6 +87,7 @@
 /* for digest and cipher support */
 #include <openssl/evp.h>
 #include <openssl/hmac.h>
+#include <openssl/md5.h>
 
 #include <sasl.h>
 #define MD5_H  /* suppress internal MD5 */
