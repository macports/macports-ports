--- ./util/neo_str.c.orig	2007-07-12 03:24:00.000000000 +0200
+++ ./util/neo_str.c	2012-04-23 17:54:46.120510185 +0200
@@ -164,7 +164,7 @@
     va_copy(tmp, ap);
     a_buf = vnsprintf_alloc(size*2, fmt, tmp);
     if (a_buf == NULL)
-      return nerr_raise(NERR_NOMEM, 
+      return nerr_raise(NERR_NOMEM, "%s",
 	  "Unable to allocate memory for formatted string");
     err = string_append(str, a_buf);
     free(a_buf);
@@ -220,7 +220,7 @@
   int x = 0;
 
   if (sep[0] == '\0') 
-    return nerr_raise (NERR_ASSERT, "separator must be at least one character");
+    return nerr_raise (NERR_ASSERT, "%s", "separator must be at least one character");
 
   err = uListInit (list, 10, 0);
   if (err) return nerr_pass(err);
