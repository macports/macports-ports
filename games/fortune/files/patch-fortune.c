--- fortune/fortune.c.orig	2001-07-02 02:35:27.000000000 +0200
+++ fortune/fortune.c	2007-09-15 12:21:05.000000000 +0200
@@ -169,6 +169,14 @@
 #endif
 
 #ifndef NO_REGEX
+#ifdef REGCOMP
+#include <regex.h>
+# define	RE_COMP(p)	(regcomp(&Re_pat, (p), REG_EXTENDED))
+# define	BAD_COMP(f)	((f) != NULL)
+# define	RE_EXEC(p)	(!regexec(&Re_pat, (p), NULL, NULL, NULL))
+
+regex_t  Re_pat;
+#else
 #ifdef REGCMP
 # define	RE_COMP(p)	(Re_pat = regcmp(p, NULL))
 # define	BAD_COMP(f)	((f) == NULL)
@@ -184,6 +192,7 @@
 
 #endif
 #endif
+#endif
 
 int
 main(ac, av)
@@ -204,7 +213,7 @@
 #endif
 
 	init_prob();
-	srandomdev();
+	srandom(getpid());
 	do {
 		get_fort();
 	} while ((Short_only && fortlen() > SLEN) ||
@@ -388,11 +397,15 @@
 		if (ignore_case)
 			pat = conv_pat(pat);
 		if (BAD_COMP(RE_COMP(pat))) {
+#ifdef REGCOMP
+			fprintf(stderr, "bad pattern: %s\n", pat);
+#else
 #ifndef REGCMP
 			fprintf(stderr, "%s\n", pat);
 #else	/* REGCMP */
 			fprintf(stderr, "bad pattern: %s\n", pat);
 #endif	/* REGCMP */
+#endif	/* REGCOMP */
 		}
 	}
 # endif	/* NO_REGEX */
