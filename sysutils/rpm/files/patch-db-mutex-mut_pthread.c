diff -Nur -x '*.orig' -x '*.rej' rpm-4.4.8/db/mutex/mut_pthread.c mezzanine_patched_rpm-4.4.8/db/mutex/mut_pthread.c
--- db/mutex/mut_pthread.c.orig	2006-12-02 11:33:09.000000000 -0500
+++ db/mutex/mut_pthread.c	2007-02-22 17:51:56.000000000 -0500
@@ -71,7 +71,7 @@
 	pthread_mutexattr_t mutexattr, *mutexattrp = NULL;
 
 	if (!LF_ISSET(DB_MUTEX_PROCESS_ONLY)) {
-#if defined(EOWNERDEAD)
+#if defined(EOWNERDEAD) && defined(PTHREAD_MUTEX_ROBUST_NP)
 		RET_SET((pthread_mutexattr_init(&mutexattr)), ret);
 		if (ret == 0) {
 			RET_SET((pthread_mutexattr_setrobust_np(
@@ -202,7 +202,7 @@
 #endif
 
 	RET_SET((pthread_mutex_lock(&mutexp->mutex)), ret);
-#if defined(EOWNERDEAD)
+#if defined(EOWNERDEAD) && defined(PTHREAD_MUTEX_ROBUST_NP)
 	if (ret == EOWNERDEAD) {
 		RET_SET((pthread_mutex_consistent_np(&mutexp->mutex)), ret);
 		ret = 0;
@@ -318,7 +318,7 @@
 #endif
 	if (F_ISSET(mutexp, DB_MUTEX_SELF_BLOCK)) {
 		RET_SET((pthread_mutex_lock(&mutexp->mutex)), ret);
-#if defined(EOWNERDEAD)
+#if defined(EOWNERDEAD) && defined(PTHREAD_MUTEX_ROBUST_NP)
 		if (ret == EOWNERDEAD) {
 			RET_SET((pthread_mutex_consistent_np(&mutexp->mutex)), ret);
 			ret = 0;


