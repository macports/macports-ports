--- app/pdb/plug_in_cmds.c.orig	Mon Feb 17 15:31:37 2003
+++ app/pdb/plug_in_cmds.c	Fri Jun 20 23:21:26 2003
@@ -66,7 +66,7 @@
 match_strings (regex_t *preg,
                gchar   *a)
 {
-  return regexec (preg, a, 0, NULL, 0);
+  return gimpregexec (preg, a, 0, NULL, 0);
 }
 
 static Argument *
@@ -229,7 +229,7 @@
   search_str = (gchar *) args[0].value.pdb_pointer;
 
   if (search_str && strlen (search_str))
-    regcomp (&sregex, search_str, REG_ICASE);
+    gimpregcomp (&sregex, search_str, REG_ICASE);
   else
     search_str = NULL;
 
