--- io.c.orig	Sun Oct 13 14:29:06 2002
+++ io.c	Sun Oct 13 14:29:18 2002
@@ -158,7 +158,7 @@
 	{
 	long *p,*pe;
 	for (p=c,pe=c+100; p<pe; *p++ =0);
-	time(&initialtime);             srandomdev();
+	time(&initialtime);             srandom(getpid());
 	lcreat((char*)0);	/* open buffering for output to terminal */
 	}
 
