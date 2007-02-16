--- gencat/genlib.c	2006-08-02 20:11:44.000000000 +0200
+++ gencat/genlib.c	2007-02-16 21:38:35.000000000 +0100
@@ -55,6 +55,7 @@
 #endif
 
 #ifndef __linux__
+#ifndef __APPLE__
 #include <memory.h>
 static int bcopy(src, dst, length)
 char *src, *dst;
@@ -71,6 +72,7 @@
 #else
 #include <string.h>
 #endif
+#endif
 
 #include <sys/file.h>
 #include <ctype.h>
