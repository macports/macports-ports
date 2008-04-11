--- lib/ssl/c_src/esock_openssl.c.orig	2008-03-12 22:15:41.000000000 -0700
+++ lib/ssl/c_src/esock_openssl.c	2008-03-12 22:16:01.000000000 -0700
@@ -905,8 +905,8 @@
     }
 
     /* info callback */
-    if (debug) 
-	SSL_CTX_set_info_callback(ctx, info_callback);
+    /*if (debug) 
+	SSL_CTX_set_info_callback(ctx, info_callback); */
 
     DEBUGF(("set_ssl_parameters: done\n"));
     /* Free arg list */
