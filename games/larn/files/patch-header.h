--- header.h.orig	2002-05-08 15:39:10.000000000 -0500
+++ header.h	2014-04-20 14:21:13.000000000 -0500
@@ -360,7 +360,7 @@
 
 char *fortune(),*lgetw(),*lgetl();
 char *tmcapcnv();
-long paytaxes(),lgetc(),lrint();
+long paytaxes(),lgetc(),lrint_x();
 unsigned long readnum();
 
 	/* macro to create scroll #'s with probability of occurrence */
