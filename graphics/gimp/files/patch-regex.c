--- app/regex.c.orig	Tue Sep 17 20:15:02 2002
+++ app/regex.c	Mon Sep 16 15:42:07 2002
@@ -5511,7 +5511,7 @@
    the return codes and their meanings.)  */
 
 int
-regcomp (preg, pattern, cflags)
+gimpregcomp (preg, pattern, cflags)
     regex_t *preg;
     const char *pattern;
     int cflags;
@@ -5589,7 +5589,7 @@
    We return 0 if we find a match and REG_NOMATCH if not.  */
 
 int
-regexec (preg, string, nmatch, pmatch, eflags)
+gimpregexec (preg, string, nmatch, pmatch, eflags)
     const regex_t *preg;
     const char *string;
     size_t nmatch;
@@ -5694,7 +5694,7 @@
 /* Free dynamically allocated space used by PREG.  */
 
 void
-regfree (preg)
+gimpregfree (preg)
     regex_t *preg;
 {
   if (preg->buffer != NULL)
