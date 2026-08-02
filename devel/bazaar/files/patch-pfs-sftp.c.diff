--- src/baz/libarch/pfs-sftp.c.orig	2005-06-21 07:59:37.000000000 +1000
+++ src/baz/libarch/pfs-sftp.c	2006-11-16 03:16:14.000000000 +1100
@@ -1496,7 +1496,7 @@
    */
   arch_uri_heuristics (&parsed_uri);
 
-  *user = str_save (0, parsed_uri.authinfo);
+  *user = str_save (0, parsed_uri.userinfo);
   *hostname = str_save (0, parsed_uri.host);
   if (parsed_uri.port)
     {
