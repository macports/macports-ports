--- app/plug_in_cmds.c.orig	Tue Sep 17 20:14:32 2002
+++ app/plug_in_cmds.c	Mon Sep 16 15:47:51 2002
@@ -51,7 +51,7 @@
 match_strings (regex_t *preg,
                gchar   *a)
 {
-  return regexec (preg, a, 0, NULL, 0);
+  return gimpregexec (preg, a, 0, NULL, 0);
 }
 
 static Argument *
@@ -208,7 +208,7 @@
   search_str = (gchar *) args[0].value.pdb_pointer;
 
   if (search_str && strlen (search_str))
-    regcomp (&sregex, search_str, REG_ICASE);
+    gimpregcomp (&sregex, search_str, REG_ICASE);
   else
     search_str = NULL;
 
