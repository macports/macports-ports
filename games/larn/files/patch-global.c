--- global.c.orig	2002-05-08 16:39:10.000000000 -0400
+++ global.c	2006-04-17 21:41:44.000000000 -0400
@@ -79,7 +79,7 @@
 	if (c[LEVEL] != i)
 		{
 		cursors();
-		beep(); lprintf("\nWelcome to level %d",(long)c[LEVEL]);	/* if we changed levels	*/
+		beep(); lprintf(2,"\nWelcome to level %d",(long)c[LEVEL]);	/* if we changed levels	*/
 		}
 	bottomline();
 	}
@@ -109,7 +109,7 @@
 	if (i!=c[LEVEL])
 		{
 		cursors();
-		beep(); lprintf("\nYou went down to level %d!",(long)c[LEVEL]);
+		beep(); lprintf(2,"\nYou went down to level %d!",(long)c[LEVEL]);
 		}
 	bottomline();
 	}
@@ -381,7 +381,7 @@
 	int itm;
 	if ((k<0) || (k>25)) return(0);
 	itm = iven[k];	cursors();
-	if (itm==0) { lprintf("\nYou don't have item %c! ",k+'a'); return(1); }
+	if (itm==0) { lprintf(2,"\nYou don't have item %c! ",k+'a'); return(1); }
 	if (item[playerx][playery])
 		{ beep(); lprcat("\nThere's something here already"); return(1); }
 	if (playery==MAXY-1 && playerx==33) return(1); /* not in entrance */
