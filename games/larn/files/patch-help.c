--- help.c.orig	2002-05-08 16:39:10.000000000 -0400
+++ help.c	2006-04-17 21:41:53.000000000 -0400
@@ -80,7 +80,7 @@
 	{
 	if (lopen(helpfile)<0)
 		{
-		lprintf("Can't open help file \"%s\" ",helpfile);
+		lprintf(2,"Can't open help file \"%s\" ",helpfile);
 		lflush(); sleep(4);	drawscreen();	setscroll(); return(-1);
 		}
 	resetscroll();  return(lgetc() - '0');
