--- http/http_server.c.orig	2005-01-21 16:01:58.000000000 -0500
+++ http/http_server.c	2015-03-23 19:34:45.664653000 -0400
@@ -197,7 +197,7 @@
 		_http_ssl_init();
 
 		/* Initialize SSL context for this server */
-		if ((serv->ssl = SSL_CTX_new(SSLv2_server_method())) == NULL) {
+		if ((serv->ssl = SSL_CTX_new(SSLv23_server_method())) == NULL) {
 			ssl_log(http_server_ssl_logger, serv);
 			goto fail;
 		}
