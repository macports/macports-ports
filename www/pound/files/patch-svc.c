--- svc.c	2006-12-12 09:04:50.000000000 +0900
+++ svc.c	2006-12-09 17:39:26.000000000 +0900
@@ -625,6 +625,7 @@
 }
 
 static pthread_mutex_t  host_mut;       /* mutex to protect gethostbyname */
+static int              host_mut_initialized = 0;
 
 /*
  * Find if a redirect needs rewriting
@@ -667,6 +668,11 @@
     memset(&addr, 0, sizeof(addr));
     addr.sin_family = AF_INET;
     /* this is to avoid the need for gethostbyname_r */
+    if(!host_mut_initialized) {
+        host_mut_initialized = 1; 
+        if(ret_val = pthread_mutex_init(&host_mut, NULL))
+            logmsg(LOG_WARNING, "need_rewrite() create: %s", strerror(ret_val));
+    }
     if(ret_val = pthread_mutex_lock(&host_mut))
         logmsg(LOG_WARNING, "need_rewrite() lock: %s", strerror(ret_val));
     if((he = gethostbyname(host)) == NULL || he->h_addr_list[0] == NULL) {
