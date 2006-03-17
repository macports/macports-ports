--- cdda2wav/cdda2wav.c.orig    2004-08-24 17:06:14.000000000 +0200
+++ cdda2wav/cdda2wav.c 2005-05-19 17:18:14.000000000 +0200
@@ -970,7 +970,7 @@
        dontneedroot();
 }
 #else
-#if      defined _POSIX_PRIORITY_SCHEDULING
+#if      defined _POSIX_PRIORITY_SCHEDULING && (_POSIX_PRIORITY_SCHEDULING -0 > 0)
 #include <sched.h>
 
 static void
