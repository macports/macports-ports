--- src/common/process.c.orig	Mon Jun 28 17:26:59 2004
+++ src/common/process.c	Mon Jun 28 17:27:12 2004
@@ -172,13 +172,13 @@
 
 
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
 } /* init_process */
