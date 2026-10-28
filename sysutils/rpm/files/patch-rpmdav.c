--- rpmio/rpmdav.c.orig	Tue Feb 20 00:51:07 2007
+++ rpmio/rpmdav.c	Thu Jun 28 15:31:30 2007
@@ -1679,7 +1679,7 @@
     dp->d_reclen = 0;		/* W2DO? */
 
 #if !(defined(hpux) || defined(__hpux) || defined(sun))
-#if !defined(__APPLE__) && !defined(__FreeBSD_kernel__)
+#if !defined(__APPLE__) && !defined(__FreeBSD_kernel__) && !defined(__FreeBSD__)
     dp->d_off = 0;		/* W2DO? */
 #endif
 /*@-boundsread@*/
