--- source/dcc.c.orig	Tue Mar 15 19:35:22 2005
+++ source/dcc.c	Sat Mar 26 00:59:36 2005
@@ -1192,7 +1192,7 @@
 
 	if (dcc->flags & DCC_QUOTED)
 	{
-		int	len = strlen(text);
+		size_t	len = strlen(text);
 		text = dequote_it(text, &len);
 		writeval = write(dcc->socket, text, len);
 		new_free(&text);
