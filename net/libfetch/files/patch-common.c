--- common.c.orig	2005-02-16 13:46:46.000000000 +0100
+++ common.c	2010-10-14 08:44:43.000000000 +0200
@@ -327,7 +327,7 @@
 
 	SSL_load_error_strings();
 
-	conn->ssl_meth = SSLv23_client_method();
+	conn->ssl_meth = (SSL_METHOD *) SSLv23_client_method();
 	conn->ssl_ctx = SSL_CTX_new(conn->ssl_meth);
 	SSL_CTX_set_mode(conn->ssl_ctx, SSL_MODE_AUTO_RETRY);
 
