--- ../sword-1.5.7.orig/src/utilfuns/zlib/untgz.c	Fri Mar 23 01:00:15 2001
+++ src/utilfuns/zlib/untgz.c	Tue May 11 22:25:27 2004
@@ -11,7 +11,7 @@
 #include <time.h>
 #include <errno.h>
 #include <fcntl.h>
-#ifdef unix
+#ifdef UNIX
 # include <unistd.h>
 #else
 # include <direct.h>
