--- plug-ins/script-fu/interp_regex.c.orig	Sun Jan  5 13:11:51 2003
+++ plug-ins/script-fu/interp_regex.c	Fri Jun 20 23:24:19 2003
@@ -66,7 +66,7 @@
   result->type = tc_regex;
   result->storage_as.string.data = (char *) h;
   h->r = (regex_t *) must_malloc (sizeof (regex_t));
-  if ((error = regcomp (h->r, str, iflags)))
+  if ((error = gimpregcomp (h->r, str, iflags)))
     {
       regerror (error, h->r, errbuff, sizeof (errbuff));
       return (my_err (errbuff, pattern));
@@ -99,7 +99,7 @@
   LISP result;
   struct tc_regex *h;
   h = get_tc_regex (ptr);
-  if ((error = regexec (h->r,
+  if ((error = gimpregexec (h->r,
 		       get_c_string (str),
 		       h->nmatch,
 		       h->m,
@@ -119,7 +119,7 @@
   if ((h = (struct tc_regex *) ptr->storage_as.string.data))
     {
       if ((h->compflag) && h->r)
-	regfree (h->r);
+	gimpregfree (h->r);
       if (h->r)
 	{
 	  free (h->r);
