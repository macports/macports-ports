--- f_util.c.orig	2007-11-06 17:30:11.000000000 +0100
+++ f_util.c	2007-11-06 17:31:43.000000000 +0100
@@ -781,7 +781,7 @@
     else strcpy(dirname, ".");
 
     if (access(dirname, W_OK) == 0) {  /* OK - the directory is writable */
-      sprintf(unc, "gunzip -q %s", name);
+      sprintf(unc, "gunzip -q -- %s", name);
       if (system(unc) != 0)
 	file_msg("Couldn't uncompress the file: \"%s\"", unc);
       strcpy(name, plainname);
@@ -792,7 +792,7 @@
 	  sprintf(tmpfile, "%s%s", TMPDIR, c);
       else
 	  sprintf(tmpfile, "%s/%s", TMPDIR, plainname);
-      sprintf(unc, "gunzip -q -c %s > %s", name, tmpfile);
+      sprintf(unc, "gunzip -q -c -- %s > %s", name, tmpfile);
       if (system(unc) != 0)
 	  file_msg("Couldn't uncompress the file: \"%s\"", unc);
       file_msg ("Uncompressing file %s in %s because it is in a read-only directory",
