*** src/ec_threads.orig	Fri Aug  6 20:21:51 2004
--- src/ec_threads.c	Fri Aug  6 20:22:42 2004
***************
*** 245,252 ****
--- 245,256 ----
     /* send the cancel signal to the thread */
     pthread_cancel((pthread_t)id);
  
+ #ifndef OS_DARWIN
+          /* XXX - darwin is broken, pthread_join hangs up forever */
+          
     /* wait until it has finished */
     pthread_join((pthread_t)id, NULL);
+ #endif
  
     DEBUG_MSG("ec_thread_destroy -- [%s] terminated", ec_thread_getname(id));
     
