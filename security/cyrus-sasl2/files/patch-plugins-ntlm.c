--- plugins/ntlm.c.orig	2005-08-29 14:55:01.000000000 +0900
+++ plugins/ntlm.c	2005-08-29 14:55:03.000000000 +0900
@@ -77,6 +77,7 @@
 #include <openssl/hmac.h>
 #include <openssl/des.h>
 #include <openssl/opensslv.h>
+#include <openssl/md5.h>
 #if (OPENSSL_VERSION_NUMBER >= 0x0090700f) && \
      !defined(OPENSSL_ENABLE_OLD_DES_SUPPORT)
 # define des_cblock DES_cblock
