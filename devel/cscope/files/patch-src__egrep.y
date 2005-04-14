--- src/egrep.y.orig	2005-04-14 19:02:52.000000000 -0400
+++ src/egrep.y	2005-04-14 19:03:00.000000000 -0400
@@ -603,25 +603,6 @@
 	return(0);
 }
 
-/* FIXME HBB: should export this to a separate file and use
- * AC_REPLACE_FUNCS() */
-#if BSD
-/*LINTLIBRARY*/
-/*
- * Set an array of n chars starting at sp to the character c.
- * Return sp.
- */
-char *
-memset(char *sp, char c, int n)
-{
-	char *sp0 = sp;
-
-	while (--n >= 0)
-		*sp++ = c;
-	return (sp0);
-}
-#endif
-
 void
 egrepcaseless(int i)
 {
