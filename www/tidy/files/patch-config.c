--- config.c.orig	Sat Aug  5 01:21:05 2000
+++ config.c	Mon Jul  8 23:07:17 2002
@@ -94,6 +94,7 @@
 Bool TidyMark = yes;        /* add meta element indicating tidied doc */
 Bool Emacs = no;            /* if true format error output for GNU Emacs */
 Bool LiteralAttribs = no;   /* if true attributes may use newlines */
+Bool PreserveEntities = no; /* if true don't convert entities to chars */
 
 typedef struct _lex PLex;
 
@@ -186,6 +187,7 @@
     {"doctype",         {(int *)&doctype_str},      ParseDocType},
     {"fix-backslash",   {(int *)&FixBackslash},     ParseBool},
     {"gnu-emacs",       {(int *)&Emacs},            ParseBool},
+    {"preserve-entities", {(int *)&PreserveEntities}, ParseBool},
 
   /* this must be the final entry */
     {0,          0,             0}
@@ -392,7 +394,8 @@
         home_dir = passwd->pw_dir;
     }
 
-    if (p = realloc(expanded_filename, strlen(filename)+strlen(home_dir)+1))
+    if (home_dir != NULL &&
+	(p = realloc(expanded_filename, strlen(filename)+strlen(home_dir)+1)))
     {
         strcat(strcpy(expanded_filename = p, home_dir), filename);
         return(expanded_filename);
@@ -423,7 +426,10 @@
     /* open the file and parse its contents */
 
     if ((fin = fopen(fname, "r")) == null)
-        FileError(stderr, fname);
+    {
+        if (FileExists(fname))		/* quiet file open error on */
+            FileError(stderr, fname);   /* non-existent file */
+    }
     else
     {
         config_text = null;
@@ -533,6 +539,12 @@
     {
         QuoteAmpersand = yes;
         HideEndTags = no;
+    }
+
+ /* Avoid &amp;copy; in preserve-entities case */
+    if (PreserveEntities)
+    {
+       QuoteAmpersand = no;
     }
 }
 
