--- system.h.orig	Mon Aug  4 22:23:50 2003
+++ system.h	Wed Dec 29 05:14:07 2004
@@ -170,7 +170,6 @@
 # include <string.h>
 #else
 # include <strings.h>
-char *memchr ();
 #endif
 
 #include <errno.h>
