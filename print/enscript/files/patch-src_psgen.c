--- src/psgen.c.orig
+++ src/psgen.c
@@ -2034,8 +2034,9 @@
   else
     {
       ftail++;
-      strncpy (buf, fname, ftail - fname);
-      buf[ftail - fname] = '\0';
+      i = ftail - fname >= sizeof (buf)-1 ? sizeof (buf)-1 : ftail - fname;
+      strncpy (buf, fname, i);
+      buf[i] = '\0';
     }
 
   if (nup > 1)
@@ -2385,9 +2386,10 @@
   MESSAGE (2, (stderr, "^@epsf=\"%s\"\n", token->u.epsf.filename));
 
   i = strlen (token->u.epsf.filename);
+  /*
   if (i > 0 && token->u.epsf.filename[i - 1] == '|')
     {
-      /* Read EPS data from pipe. */
+      / * Read EPS data from pipe. * /
       token->u.epsf.pipe = 1;
       token->u.epsf.filename[i - 1] = '\0';
       token->u.epsf.fp = popen (token->u.epsf.filename, "r");
@@ -2400,6 +2402,7 @@
 	}
     }
   else
+  */
     {
       char *filename;
 
