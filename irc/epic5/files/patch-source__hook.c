--- source/hook.c.orig	Fri Mar 11 20:40:22 2005
+++ source/hook.c	Sat Mar 26 00:59:36 2005
@@ -1855,7 +1855,7 @@
 	int sernum;
 	int halt = 0;
 	int id;
-	int retlen;
+	size_t retlen;
 	char *nam;
 	char *str;
 	char *hookname;
