--- src/lib/howl/MacOSX/macosx_salt.h.orig	Wed Mar 30 17:28:28 2005
+++ src/lib/howl/MacOSX/macosx_salt.h	Wed Mar 30 17:28:39 2005
@@ -33,6 +33,7 @@
 #include "macosx_socket.h"
 #include "macosx_time.h"
 #include <sys/errno.h>
+#include <pthread.h>
 
 
 #ifdef __cplusplus
@@ -46,6 +47,7 @@
 	CFRunLoopRef					m_cf_run_loop;
 	struct _sw_macosx_socket	m_sockets;
 	struct _sw_macosx_timer		m_timers;
+	pthread_mutex_t							m_mutex;
 	sw_bool							m_step;
 };
 
