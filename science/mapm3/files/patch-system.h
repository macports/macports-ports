diff -wubr ../mapm3-old/lib/system.h ./lib/system.h
--- ../mapm3-old/lib/system.h	Tue Feb  9 08:35:28 1993
+++ ./lib/system.h	Fri Nov 15 08:00:00 2002
@@ -191,6 +191,9 @@
 #ifdef _SYS_ULTRIX
 #define SIGHANDLE void
 #endif
+#ifdef _SYS_DARWIN
+#define SIGHANDLE void
+#endif
 
 
 
@@ -309,6 +312,13 @@
 #define QSORT_LENGTH       size_t
 #endif
 
+#ifdef _SYS_DARWIN /* should be good for any ANSI system */
+#define CALLOC_PTR_TO      void
+#define CALLOC_NUM_TYPE	   size_t
+#define SIZEOF_TYPE	   size_t
+#define QSORT_DATA_PTR_TO  void
+#define QSORT_LENGTH       size_t
+#endif
 
 
 /**************************** Terminal I/O ********************************
@@ -583,7 +593,11 @@
 #include <signal.h> 
 #include <errno.h> 	
 #include <time.h>       /* for ctime() def - Who does not have this file? */
+#ifdef _SYS_DARWIN
+#include <unistd.h>
+#else
 #include <malloc.h>
+#endif
 #include <sys/types.h>
 
 #ifdef TRY_WINSIZE
