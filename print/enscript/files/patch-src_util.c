--- src/util.c.orig
+++ src/util.c
@@ -1239,6 +1239,8 @@
 
   /* Create result. */
   cp = xmalloc (len + 1);
+  if (cp == NULL)
+      return NULL;
   for (i = 0, j = 0; string[i]; i++)
     switch (string[i])
       {
@@ -1879,6 +1881,7 @@
       char *cmd = NULL;
       int cmdlen;
       int i, pos;
+      char *cp;
 
       is->is_pipe = 1;
 
@@ -1902,12 +1905,16 @@
 		{
 		case 's':
 		  /* Expand cmd-buffer. */
-		  cmdlen += strlen (fname);
-		  cmd = xrealloc (cmd, cmdlen);
+		  if ((cp = shell_escape (fname)) != NULL)
+		    {
+		      cmdlen += strlen (cp);
+		      cmd = xrealloc (cmd, cmdlen);
 
-		  /* Paste filename. */
-		  strcpy (cmd + pos, fname);
-		  pos += strlen (fname);
+		      /* Paste filename. */
+		      strcpy (cmd + pos, cp);
+		      pos += strlen (cp);
+		      free (cp);
+		    }
 
 		  i++;
 		  break;
@@ -2115,4 +2122,37 @@
 buffer_len (Buffer *buffer)
 {
   return buffer->len;
+}
+
+/*
+ * Escapes the name of a file so that the shell groks it in 'single'
+ * quotation marks.  The resulting pointer has to be free()ed when not
+ * longer used.
+*/
+char *
+shell_escape(const char *fn)
+{
+  size_t len = 0;
+  const char *inp;
+  char *retval, *outp;
+
+  for(inp = fn; *inp; ++inp)
+    switch(*inp)
+    {
+      case '\'': len += 4; break;
+      default:   len += 1; break;
+    }
+
+  outp = retval = malloc(len + 1);
+  if(!outp)
+    return NULL; /* perhaps one should do better error handling here */
+  for(inp = fn; *inp; ++inp)
+    switch(*inp)
+    {
+      case '\'': *outp++ = '\''; *outp++ = '\\'; *outp++ = '\'', *outp++ = '\''; break;
+      default:   *outp++ = *inp; break;
+    }
+  *outp = 0;
+
+  return retval;
 }
