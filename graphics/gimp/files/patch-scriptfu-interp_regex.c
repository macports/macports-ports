--- plug-ins/script-fu/interp_regex.c.orig	Tue Sep 17 20:15:46 2002
+++ plug-ins/script-fu/interp_regex.c	Mon Sep 16 15:48:54 2002
@@ -58,7 +58,7 @@
   result->type = tc_regex;
   result->storage_as.string.data = (char *) h;
   h->r = (regex_t *) must_malloc (sizeof (regex_t));
-  if ((error = regcomp (h->r, str, iflags)))
+  if ((error = gimpregcomp (h->r, str, iflags)))
     {
       regerror (error, h->r, errbuff, sizeof (errbuff));
       return (my_err (errbuff, pattern));
@@ -91,7 +91,7 @@
   LISP result;
   struct tc_regex *h;
   h = get_tc_regex (ptr);
-  if ((error = regexec (h->r,
+  if ((error = gimpregexec (h->r,
 		       get_c_string (str),
 		       h->nmatch,
 		       h->m,
@@ -111,7 +111,7 @@
   if ((h = (struct tc_regex *) ptr->storage_as.string.data))
     {
       if ((h->compflag) && h->r)
-	regfree (h->r);
+	gimpregfree (h->r);
       if (h->r)
 	{
 	  free (h->r);
