--- app/pdb/procedural_db_cmds.c.orig	Mon Jun  2 17:23:17 2003
+++ app/pdb/procedural_db_cmds.c	Fri Jun 20 23:20:33 2003
@@ -122,7 +122,7 @@
   if (!a)
     a = "";	
 
-  return regexec (preg, a, 0, NULL, 0);
+  return gimpregexec (preg, a, 0, NULL, 0);
 }
 
 static void
@@ -367,13 +367,13 @@
 
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
