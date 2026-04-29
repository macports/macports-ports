--- ./cs/cstest.c.orig	2006-03-13 00:54:15.000000000 +0100
+++ ./cs/cstest.c	2012-04-23 17:54:05.809909855 +0200
@@ -30,7 +30,7 @@
   int x = 0;
 
   if (s == NULL)
-    return nerr_raise(NERR_NOMEM, "Unable to duplicate string in test_strfunc");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to duplicate string in test_strfunc");
 
   while (s[x]) {
     s[x] = tolower(s[x]);
