--- src/baz/libarch/tests/unit-sftp.c.orig	2005-06-21 07:59:37.000000000 +1000
+++ src/baz/libarch/tests/unit-sftp.c	2006-11-16 03:22:04.000000000 +1100
@@ -44,7 +44,7 @@
   invariant_str_cmp (parsed_uri.host, "email.com@host.phwoar");
   arch_uri_heuristics (&parsed_uri);
   invariant_str_cmp (parsed_uri.host, "host.phwoar");
-  invariant_str_cmp (parsed_uri.authinfo, "user@email.com");
+  invariant_str_cmp (parsed_uri.userinfo, "user@email.com");
   invariant_int_cmp (parsed_uri.port, 0);
   ne_uri_free(&parsed_uri);
 
