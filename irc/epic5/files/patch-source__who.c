--- source/who.c.orig	Wed Feb  2 19:06:01 2005
+++ source/who.c	Wed Feb  2 19:06:04 2005
@@ -1290,7 +1290,7 @@
 {
 	IsonEntry *new_i = ison_queue_top(refnum);
 	char	*do_off = NULL, *this1, *all1, *this2, *all2;
-	int	clue = 0;
+	size_t	clue = 0;
 
 	if (!new_i)
 	{
