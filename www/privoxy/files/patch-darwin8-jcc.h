--- jcc.h	2003-03-07 04:41:05.000000000 +0100
+++ jcc.h	2005-05-31 10:22:36.000000000 +0200
@@ -122,6 +122,7 @@
 #endif
 
 #ifdef OSX_DARWIN
+#include <pthread.h>
 extern pthread_mutex_t gmtime_mutex;
 extern pthread_mutex_t localtime_mutex;
 extern pthread_mutex_t gethostbyaddr_mutex;
