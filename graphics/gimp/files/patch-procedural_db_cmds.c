--- app/procedural_db_cmds.c.orig	Tue Sep 17 20:14:49 2002
+++ app/procedural_db_cmds.c	Mon Sep 16 15:48:03 2002
@@ -120,7 +120,7 @@
 match_strings (regex_t *preg,
 	       gchar   *a)
 {
-  return regexec (preg, a, 0, NULL, 0);
+  return gimpregexec (preg, a, 0, NULL, 0);
 }
 
 static void
@@ -351,13 +351,13 @@
 
   if (success)
     {
-      regcomp (&pdb_query.name_regex, name, 0);
-      regcomp (&pdb_query.blurb_regex, blurb, 0);
-      regcomp (&pdb_query.help_regex, help, 0);
-      regcomp (&pdb_query.author_regex, author, 0);
-      regcomp (&pdb_query.copyright_regex, copyright, 0);
-      regcomp (&pdb_query.date_regex, date, 0);
-      regcomp (&pdb_query.proc_type_regex, proc_type, 0);
+      gimpregcomp (&pdb_query.name_regex, name, 0);
+      gimpregcomp (&pdb_query.blurb_regex, blurb, 0);
+      gimpregcomp (&pdb_query.help_regex, help, 0);
+      gimpregcomp (&pdb_query.author_regex, author, 0);
+      gimpregcomp (&pdb_query.copyright_regex, copyright, 0);
+      gimpregcomp (&pdb_query.date_regex, date, 0);
+      gimpregcomp (&pdb_query.proc_type_regex, proc_type, 0);
     
       pdb_query.list_of_procs = NULL;
       pdb_query.num_procs = 0;
