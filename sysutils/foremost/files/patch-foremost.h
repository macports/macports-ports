diff -rubB foremost-0.69/foremost.h foremost-0.69-mac/foremost.h
--- foremost.h	Fri Jan  9 14:45:23 2004
+++ ../foremost-0.69-mac/foremost.h	Mon Oct 25 07:49:01 2004
@@ -35,6 +35,15 @@
 #include <dirent.h>
 #include <stdarg.h>
 
+#ifdef __APPLE__
+#define __UNIX
+#define  strtoull   strtoul
+#include <sys/ttycom.h>
+#include <sys/param.h>
+#include <sys/ioctl.h>
+#include <libgen.h>
+#endif  /* ifdef __APPLE__ */
+
 #ifdef __OPENBSD
 #define __UNIX
 #define  strtoull   strtoul
