--- image/image.h.orig	Wed Nov 12 11:07:35 2003
+++ image/image.h	Wed Nov 12 11:07:49 2003
@@ -182,6 +182,7 @@
 unsigned long doValToMemLSB();
 void          flipBits();
 
+#define	zopen	mgp_zopen
 ZFILE *zopen();
 int    zread();
 void   zreset();
