--- wump.c.orig	Wed Oct  9 12:30:16 2002
+++ wump.c	Wed Oct  9 12:30:26 2002
@@ -531,7 +531,7 @@
 	 * than three links, regardless of the quality of the random number
 	 * generator that we're using.
 	 */
-	srandomdev();
+	srandom(getpid());
 
 	/* initialize the cave first off. */
 	for (i = 1; i <= room_num; ++i)
