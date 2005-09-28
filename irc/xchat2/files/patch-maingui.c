--- src/fe-gtk/maingui.c.orig	2005-09-28 00:21:07.000000000 -0700
+++ src/fe-gtk/maingui.c	2005-09-28 00:21:12.000000000 -0700
@@ -1583,7 +1583,7 @@
 		return;
 
 	sess = current_sess;
-	mode = tolower (flag[0]);
+	mode = tolower ((unsigned char) flag[0]);
 
 	switch (mode)
 	{
