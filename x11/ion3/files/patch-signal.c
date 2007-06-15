--- libmainloop/signal.c.orig	2007-06-15 21:26:03.000000000 +0200
+++ libmainloop/signal.c	2007-06-15 21:26:26.000000000 +0200
@@ -44,7 +44,7 @@
 
 int mainloop_gettime(struct timeval *val)
 {
-#ifdef _POSIX_MONOTONIC_CLOCK
+#if defined(_POSIX_MONOTONIC_CLOCK) && (_POSIX_MONOTONIC_CLOCK >= 0)
     struct timespec spec;
     int ret;
     
