--- modules/ssl/ssl_engine_vars.c	2005-02-04 21:21:18.000000000 +0100
+++ modules/ssl/ssl_engine_vars.c	2005-07-10 14:22:54.000000000 +0200
@@ -47,6 +47,7 @@
 static char *ssl_var_lookup_ssl_cipher(apr_pool_t *p, conn_rec *c, char *var);
 static void  ssl_var_lookup_ssl_cipher_bits(SSL *ssl, int *usekeysize, int *algkeysize);
 static char *ssl_var_lookup_ssl_version(apr_pool_t *p, char *var);
+static char *ssl_var_lookup_ssl_comp_method(SSL *ssl);
 
 static int ssl_is_https(conn_rec *c)
 {
@@ -281,6 +282,9 @@
     else if (ssl != NULL && strlen(var) > 7 && strcEQn(var, "SERVER_", 7)) {
         if ((xs = SSL_get_certificate(ssl)) != NULL)
             result = ssl_var_lookup_ssl_cert(p, xs, var+7);
+        else if (ssl != NULL && strlen(var) >= 11 && strcEQn(var, "COMP_METHOD", 7)) {
+            result = ssl_var_lookup_ssl_comp_method(ssl);
+        }
     }
     return result;
 }
@@ -595,6 +599,39 @@
     return result;
 }
 
+static char *ssl_var_lookup_ssl_comp_method(SSL *ssl)
+{
+	char *result = "NULL";
+	#ifdef OPENSSL_VERSION_NUMBER
+	#if (OPENSSL_VERSION_NUMBER >= 0x00908000)
+    SSL_SESSION *pSession = SSL_get_session(ssl);
+
+    if (pSession) {
+        switch (pSession->compress_meth) {
+            case 0:
+		         /* default "NULL" already set */
+		         break;
+
+                 /* Defined by RFC 3749, deflate is coded by "1" */
+		         case 1:
+		             result = "DEFLATE";
+		             break;
+			
+	             /* IANA assigned compression number for LZS */
+		         case 0x40:
+		             result = "LZS";
+		             break;
+			
+		         default:
+		             result = "UNKNOWN";
+		             break;
+	       }
+     }
+	 #endif
+	 #endif
+    return result;
+}
+
 /*  _________________________________________________________________
 **
 **  SSL Extension to mod_log_config
