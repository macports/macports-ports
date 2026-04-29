--- src/baz/libarch/pfs.c.orig	2005-06-21 07:59:37.000000000 +1000
+++ src/baz/libarch/pfs.c	2006-11-16 02:44:41.000000000 +1100
@@ -513,10 +513,10 @@
     char *at_pos = str_chr_index (parsed_uri->host, '@');
     if (!at_pos)
         return;
-    parsed_uri->authinfo = str_replace (parsed_uri->authinfo, 
-					str_alloc_cat (0, parsed_uri->authinfo, "@"));
-    parsed_uri->authinfo = str_replace (parsed_uri->authinfo, 
-					str_alloc_cat_n (0, parsed_uri->authinfo, parsed_uri->host, at_pos - parsed_uri->host));
+    parsed_uri->userinfo = str_replace (parsed_uri->userinfo, 
+					str_alloc_cat (0, parsed_uri->userinfo, "@"));
+    parsed_uri->userinfo = str_replace (parsed_uri->userinfo, 
+					str_alloc_cat_n (0, parsed_uri->userinfo, parsed_uri->host, at_pos - parsed_uri->host));
     parsed_uri->host = str_replace (parsed_uri->host, str_save (0, at_pos + 1));
 }
 
