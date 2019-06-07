--- src/common/process.c.orig	2015-05-20 03:52:15.000000000 -0500
+++ src/common/process.c	2018-10-06 21:06:06.000000000 -0500
@@ -172,15 +172,15 @@
 
 
 /*
- * init_process
+ * frotz_init_process
  *
  * Initialize process variables.
  *
  */
-void init_process (void)
+void frotz_init_process (void)
 {
     finished = 0;
-} /* init_process */
+} /* frotz_init_process */
 
 
 /*
