--- src/calc.c.org	Sat May  1 10:39:37 2004
+++ src/calc.c	Sat May  1 10:40:16 2004
@@ -26,11 +26,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <signal.h>
-#ifdef HAVE_WORDEXP
-#include <wordexp.h>
-#else
 #include <glob.h>
-#endif
 #include <stdio.h>
 #include <string.h>
 #include <math.h>
@@ -2393,18 +2389,6 @@
 get_wordlist (const char *lst)
 {
 	GSList *list = NULL;
-#if HAVE_WORDEXP
-	wordexp_t we;
-	int i;
-	if G_UNLIKELY (wordexp (lst, &we, WRDE_NOCMD) != 0) {
-		gel_errorout (_("Can't expand '%s'"), lst);
-		return NULL;
-	}
-	for (i = 0; i < we.we_wordc; i++) {
-		list = g_slist_prepend (list, g_strdup (we.we_wordv[i]));
-	}
-	wordfree (&we);
-#else
 	glob_t gl;
 	int i;
 	if G_UNLIKELY (glob (lst, 0, NULL, &gl) != 0) {
@@ -2415,7 +2399,6 @@
 		list = g_slist_prepend (list, g_strdup (gl.gl_pathv[i]));
 	}
 	globfree (&gl);
-#endif
 	return list;
 }
 
