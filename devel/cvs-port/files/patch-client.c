diff -rub cvs-1.11.6.orig/src/client.c cvs-1.11.6/src/client.c
--- src/client.c	Tue Jul  8 22:09:06 2003
+++ src/client.c	Tue Jul  8 22:15:32 2003
@@ -1429,7 +1429,8 @@
    the contents of that file and write them to FILENAME.  FULLNAME is
    the name of the file for use in error messages.  FIXME-someday:
    extend this to deal with compressed files and make update_entries
-   use it.  On error, gives a fatal error.  */
+   use it.  On error, gives a fatal error.
+   If filename is NULL, do not actually write to a file    */
 static void
 read_counted_file (filename, fullname)
     char *filename;
@@ -1448,7 +1449,7 @@
     size_t nread;
     size_t nwrite;
 
-    FILE *fp;
+    FILE *fp = NULL;
 
     read_line (&size_string);
     if (size_string[0] == 'z')
@@ -1469,9 +1470,12 @@
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
@@ -1490,16 +1494,20 @@
 
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
@@ -2531,6 +2539,9 @@
 	    		  + strlen ( CVSADM_TEMPLATE )
 			  + 2 );
     sprintf ( buf, "%s/%s", short_pathname, CVSADM_TEMPLATE );
+    if (strcmp (command_name, "export") == 0)
+	    read_counted_file ( NULL, buf );
+    else
     read_counted_file ( CVSADM_TEMPLATE, buf );
     free ( buf );
 }
