--- libhttpd/src/ip_acl.c.orig	2006-03-06 00:39:36.000000000 +1100
+++ libhttpd/src/ip_acl.c	2011-06-30 17:49:16.000000000 +1000
@@ -24,6 +24,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <strings.h>
+#include <sys/types.h>
 
 #if defined(_WIN32)
 #else
