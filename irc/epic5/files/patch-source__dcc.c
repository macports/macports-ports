--- source/dcc.c.orig	Wed Feb  2 18:58:21 2005
+++ source/dcc.c	Wed Feb  2 18:58:24 2005
@@ -1155,7 +1155,7 @@
 
 	if (dcc->flags & DCC_QUOTED)
 	{
-		int	len = strlen(text);
+		size_t	len = strlen(text);
 		text = dequote_it(text, &len);
 		writeval = write(dcc->socket, text, len);
 		new_free(&text);
