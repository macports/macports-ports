--- lib5250/sslstream.c.orig	2008-11-21 08:12:21 UTC
+++ lib5250/sslstream.c
@@ -368,13 +368,19 @@ int tn5250_ssl_stream_init (Tn5250Stream
         methstr[4] = '\0';
    }
 
+#if 0
    if (!strcmp(methstr, "ssl2")) {
         meth = SSLv2_client_method();         
         TN5250_LOG(("SSL Method = SSLv2_client_method()\n"));
-   } else if (!strcmp(methstr, "ssl3")) {
+   } else 
+#endif
+#ifndef OPENSSL_NO_SSL3
+   if (!strcmp(methstr, "ssl3")) {
         meth = SSLv3_client_method();         
         TN5250_LOG(("SSL Method = SSLv3_client_method()\n"));
-   } else {
+   } else 
+#endif
+   {
         meth = SSLv23_client_method();         
         TN5250_LOG(("SSL Method = SSLv23_client_method()\n"));
    }
