--- ../ex/ex_script.c.orig	2005-09-28 19:37:10.000000000 -0700
+++ ../ex/ex_script.c	2005-09-28 19:37:23.000000000 -0700
@@ -12,6 +12,10 @@
 
 #include "config.h"
 
+#ifdef __APPLE__
+#undef HAVE_SYS5_PTY
+#endif
+
 #ifndef lint
 static const char sccsid[] = "$Id: patch-ex__ex_script.c,v 1.1 2005/09/29 02:56:02 toby Exp $ (Berkeley) $Date: 2005/09/29 02:56:02 $";
 #endif /* not lint */
@@ -45,6 +49,10 @@
 #include "script.h"
 #include "pathnames.h"
 
+#ifdef __APPLE__
+#undef HAVE_SYS5_PTY
+#endif
+
 static void	sscr_check __P((SCR *));
 static int	sscr_getprompt __P((SCR *));
 static int	sscr_init __P((SCR *));
