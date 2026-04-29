--- kcthread.cc.orig	2012-09-23 22:11:51.000000000 -0700
+++ kcthread.cc	2012-09-23 22:12:24.000000000 -0700
@@ -668,7 +668,7 @@ void SpinLock::lock() {
 #elif _KC_GCCATOMIC
   _assert_(true);
   uint32_t wcnt = 0;
-  while (!__sync_bool_compare_and_swap(&opq_, 0, 1)) {
+  while (!__sync_bool_compare_and_swap((uintptr_t *)&opq_, 0, 1)) {
     if (wcnt >= LOCKBUSYLOOP) {
       Thread::chill();
     } else {
@@ -693,7 +693,7 @@ bool SpinLock::lock_try() {
   return ::InterlockedCompareExchange((LONG*)&opq_, 1, 0) == 0;
 #elif _KC_GCCATOMIC
   _assert_(true);
-  return __sync_bool_compare_and_swap(&opq_, 0, 1);
+  return __sync_bool_compare_and_swap((uintptr_t *)&opq_, 0, 1);
 #else
   _assert_(true);
   ::pthread_spinlock_t* spin = (::pthread_spinlock_t*)opq_;
