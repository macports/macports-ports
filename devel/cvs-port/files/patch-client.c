diff -rub cvs-1.11.5.orig/src/client.c cvs-1.11.5/src/client.c
--- src/client.c	Tue Jul  8 21:51:08 2003
+++ src/client.c	Tue Jul  8 21:51:57 2003
@@ -1431,7 +1431,8 @@
    the contents of that file and write them to FILENAME.  FULLNAME is
    the name of the file for use in error messages.  FIXME-someday:
    extend this to deal with compressed files and make update_entries
-   use it.  On error, gives a fatal error.  */
+   use it.  On error, gives a fatal error.
+   If filename is NULL, do not actually write to a file    */
 static void
 read_counted_file (filename, fullname)
     char *filename;
@@ -1450,7 +1451,7 @@
     size_t nread;
     size_t nwrite;
 
-    FILE *fp;
+    FILE *fp = NULL;
 
     read_line (&size_string);
     if (size_string[0] == 'z')
@@ -1471,9 +1472,12 @@
        is binary or not.  I haven't carefully looked into whether
        CVS/Template files should use local text file conventions or
        not.  */
+    if (filename != NULL) {
     fp = CVS_FOPEN (filename, "wb");
     if (fp == NULL)
 	error (1, errno, "cannot write %s", fullname);
+    }
+
     nread = size;
     nwrite = 0;
     pread = buf;
@@ -1492,16 +1496,20 @@
 
 	if (nwrite > 0)
 	{
+	    if (fp != NULL) {
 	    n = fwrite (pwrite, 1, nwrite, fp);
 	    if (ferror (fp))
 		error (1, errno, "cannot write %s", fullname);
+	    }
 	    nwrite -= n;
 	    pwrite += n;
 	}
     }
     free (buf);
+    if (fp != NULL) {
     if (fclose (fp) < 0)
 	error (1, errno, "cannot close %s", fullname);
+    }
 }
 
 /* OK, we want to swallow the "U foo.c" response and then output it only
@@ -2529,9 +2537,15 @@
     char *short_pathname;
     char *filename;
 {
+    char *output;
+    if (strcmp (command_name, "export") == 0)
+	    output = NULL;
+    else
+	    output = CVSADM_TEMPLATE;
+
     /* FIXME: should be computing second argument from CVSADM_TEMPLATE
        and short_pathname.  */
-    read_counted_file (CVSADM_TEMPLATE, "<CVS/Template file>");
+    read_counted_file (output, "<CVS/Template file>");
 }
 
 static void handle_template PROTO ((char *, int));
