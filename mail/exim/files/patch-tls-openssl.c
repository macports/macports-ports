--- src/tls-openssl.c.orig	2007-01-09 01:25:37.000000000 +1100
+++ src/tls-openssl.c	2009-09-16 14:45:26.000000000 +1000
@@ -343,8 +343,8 @@
 /* Set up the information callback, which outputs if debugging is at a suitable
 level. */
 
-if (!(SSL_CTX_set_info_callback(ctx, (void (*)())info_callback)))
-  return tls_error(US"SSL_CTX_set_info_callback", host);
+/* This function returns no diagnostic information! */
+SSL_CTX_set_info_callback(ctx, (void (*)())info_callback);
 
 /* The following patch was supplied by Robert Roselius */
 
