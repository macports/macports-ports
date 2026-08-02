--- te_subs.c.orig	Sat Jan 17 03:31:40 2004
+++ te_subs.c	Sat Jan 17 03:31:53 2004
@@ -231,7 +231,7 @@
     char c;
     {
     if (isdigit(c)) return(c - '0' + 1);
-    else if isalpha(c) return(mapch_l[c] - 'a' + 11);
+    else if (isalpha(c)) return(mapch_l[c] - 'a' + 11);
     else if (fors)
 	{
 	if (c == '_') return (SERBUF);
