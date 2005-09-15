--- jcc.h.orig	2003-03-06 20:41:05.000000000 -0700
+++ jcc.h	2005-09-14 21:53:05.000000000 -0600
@@ -99,8 +99,7 @@
 extern "C" {
 #endif
 
-struct client_state;
-struct file_list;
+#include "project.h"
 
 /* Global variables */
 
@@ -122,6 +121,7 @@
 #endif
 
 #ifdef OSX_DARWIN
+#include <pthread.h>
 extern pthread_mutex_t gmtime_mutex;
 extern pthread_mutex_t localtime_mutex;
 extern pthread_mutex_t gethostbyaddr_mutex;
