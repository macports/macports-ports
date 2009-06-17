--- id_parse.c.orig	2009-06-16 21:53:13.000000000 -0700
+++ id_parse.c	2009-06-16 21:53:19.000000000 -0700
@@ -38,7 +38,8 @@
 {
     char c, *cp, *tmp_charset;
     fd_set rs;
-    int pos, res=0, lp, fp;
+    int res=0, lp, fp;
+    size_t pos;
     
     errno = 0;
     
