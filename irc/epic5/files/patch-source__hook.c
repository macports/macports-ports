--- source/hook.c.orig	Wed Feb  2 19:01:35 2005
+++ source/hook.c	Wed Feb  2 19:01:38 2005
@@ -1816,7 +1816,7 @@
 	int sernum;
 	int halt = 0;
 	int id;
-	int retlen;
+	size_t retlen;
 	char *nam;
 	char *str;
 	char *hookname;
