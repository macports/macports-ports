--- libsoup/soup-gnutls.c.orig	2004-10-20 18:31:22.000000000 +0200
+++ libsoup/soup-gnutls.c
@@ -63,7 +63,9 @@ verify_certificate (gnutls_session sessi
 	}
 
 	if (status & GNUTLS_CERT_INVALID ||
+#if defined(GNUTLS_CERT_NOT_TRUSTED)
 	    status & GNUTLS_CERT_NOT_TRUSTED ||
+#endif
 	    status & GNUTLS_CERT_REVOKED)
 	{
 		g_set_error (err, SOUP_SSL_ERROR,
