--- src/common.h	2006-04-13 22:00:07.000000000 -0500
+++ src/common.h	2006-04-13 22:00:14.000000000 -0500
@@ -716,7 +716,6 @@
 
 /* Input thread and thread function */
 #include <pthread.h>
-extern pthread_t input_thread;
 void *input_func(void *);
 
 /*
