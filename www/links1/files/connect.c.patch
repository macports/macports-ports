--- connect.c.orig	2017-02-08 12:41:56 UTC
+++ connect.c
@@ -106,7 +106,7 @@ void ssl_want_read(struct connection *c)
 
 	set_timeout(c);
 
-	if (c->no_tsl) c->ssl->options |= SSL_OP_NO_TLSv1;
+	if (c->no_tsl) SSL_set_options(c->ssl, SSL_OP_NO_TLSv1);
 	switch (SSL_get_error(c->ssl, SSL_connect(c->ssl))) {
 		case SSL_ERROR_NONE:
 			c->newconn = NULL;
@@ -186,7 +186,7 @@ void connected(struct connection *c)
 	if (c->ssl) {
 		c->ssl = getSSL();
 		SSL_set_fd(c->ssl, *b->sock);
-		if (c->no_tsl) c->ssl->options |= SSL_OP_NO_TLSv1;
+		if (c->no_tsl) SSL_set_options(c->ssl, SSL_OP_NO_TLSv1);
 		switch (SSL_get_error(c->ssl, SSL_connect(c->ssl))) {
 			case SSL_ERROR_WANT_READ:
 				setcstate(c, S_SSL_NEG);
