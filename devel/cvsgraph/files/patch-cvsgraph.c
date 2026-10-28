--- cvsgraph.c.orig	Mon Sep 13 16:27:17 2004
+++ cvsgraph.c	Mon Sep 13 16:40:48 2004
@@ -1045,7 +1045,11 @@
 	tm.tm_mon--;
 	if(tm.tm_year > 1900)
 		tm.tm_year -= 1900;
+#ifdef __APPLE__
+	t = timegm(&tm);
+#else
 	t = mktime(&tm) - timezone;
+#endif
 	if(n != 6 || t == (time_t)(-1))
 	{
 		add_string_str("<invalid date>");
