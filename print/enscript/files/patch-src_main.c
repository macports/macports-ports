--- src/main.c.orig
+++ src/main.c
@@ -1546,9 +1546,13 @@
       buffer_append (&cmd, intbuf);
       buffer_append (&cmd, " ");
 
-      buffer_append (&cmd, "-Ddocument_title=\"");
-      buffer_append (&cmd, title);
-      buffer_append (&cmd, "\" ");
+      buffer_append (&cmd, "-Ddocument_title=\'");
+      if ((cp = shell_escape (title)) != NULL)
+	{
+	  buffer_append (&cmd, cp);
+	  free (cp);
+	}
+      buffer_append (&cmd, "\' ");
 
       buffer_append (&cmd, "-Dtoc=");
       buffer_append (&cmd, toc ? "1" : "0");
@@ -1565,8 +1569,14 @@
       /* Append input files. */
       for (i = optind; i < argc; i++)
 	{
-	  buffer_append (&cmd, " ");
-	  buffer_append (&cmd, argv[i]);
+	  char *cp;
+	  if ((cp = shell_escape (argv[i])) != NULL)
+	    {
+	      buffer_append (&cmd, " \'");
+	      buffer_append (&cmd, cp);
+	      buffer_append (&cmd, "\'");
+	      free (cp);
+	    }
 	}
 
       /* And do the job. */
@@ -1627,7 +1637,7 @@
 				 buffer_ptr (opts), buffer_len (opts));
 	    }
 
-	  buffer_append (&buffer, " \"%s\"");
+	  buffer_append (&buffer, " \'%s\'");
 
 	  input_filter = buffer_copy (&buffer);
 	  input_filter_stdin = "-";
