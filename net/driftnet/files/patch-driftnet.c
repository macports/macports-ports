--- driftnet.c.orig	Mon Jul 14 10:19:37 2003
+++ driftnet.c	Mon Jul 14 10:19:51 2003
@@ -11,6 +11,7 @@
 
 #undef NDEBUG
 
+#include <sys/types.h>
 #include <assert.h>
 #include <dirent.h>
 #include <errno.h>
