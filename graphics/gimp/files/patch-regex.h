--- app/regex.h.orig	Tue Sep 17 20:15:07 2002
+++ app/regex.h	Mon Sep 16 15:41:47 2002
@@ -511,14 +511,14 @@
 #endif
 
 /* POSIX compatibility.  */
-extern int regcomp _RE_ARGS ((regex_t *preg, const char *pattern, int cflags));
-extern int regexec
+extern int gimpregcomp _RE_ARGS ((regex_t *preg, const char *pattern, int cflags));
+extern int gimpregexec
   _RE_ARGS ((const regex_t *preg, const char *string, size_t nmatch,
              regmatch_t pmatch[], int eflags));
 extern size_t regerror
   _RE_ARGS ((int errcode, const regex_t *preg, char *errbuf,
              size_t errbuf_size));
-extern void regfree _RE_ARGS ((regex_t *preg));
+extern void gimpregfree _RE_ARGS ((regex_t *preg));
 
 
 #ifdef __cplusplus
