--- lib/ssl/c_src/esock_openssl.c.orig	2008-11-04 12:17:23.000000000 +0100
+++ lib/ssl/c_src/esock_openssl.c	2008-11-06 07:46:48.000000000 +0100
@@ -907,8 +907,8 @@
     }
 
     /* info callback */
-    if (debug) 
-	SSL_CTX_set_info_callback(ctx, info_callback);
+    /*if (debug) 
+	SSL_CTX_set_info_callback(ctx, info_callback); */
 
     DEBUGF(("set_ssl_parameters: done\n"));
     /* Free arg list */
