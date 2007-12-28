--- compat/Thread.c.orig	2007-05-04 20:41:46.000000000 +0200
+++ compat/Thread.c	2007-05-04 20:42:15.000000000 +0200
@@ -202,7 +202,7 @@
 #if   defined( HAVE_POSIX_THREAD )
             // Cray J90 doesn't have pthread_cancel; Iperf works okay without
 #ifdef HAVE_PTHREAD_CANCEL
-            pthread_cancel( oldTID );
+            pthread_cancel( thread->mTID );
 #endif
 #else // Win32
             // this is a somewhat dangerous function; it's not
