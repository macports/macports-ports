--- flood_net.c.orig	Tue Sep  9 18:49:50 2003
+++ flood_net.c	Thu Oct  2 16:45:13 2003
@@ -78,7 +78,7 @@
     }
 
     if ((rv = apr_socket_create(&fs->socket, APR_INET, SOCK_STREAM,
-                                APR_PROTO_TCP, pool)) != APR_SUCCESS) {
+                                pool)) != APR_SUCCESS) {
         if (status) {
             *status = rv;
         }
