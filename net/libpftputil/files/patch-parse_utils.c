--- src/parse_utils.c	Sun Oct 31 22:49:31 2004
+++ ../../parse_utils.c	Wed Jan 12 20:14:10 2005
@@ -11,6 +11,9 @@
 #include <arpa/inet.h>
 #include <netdb.h>
 
+#include <netinet/in.h>
+#include <stdint.h>
+
 #include "str.h"
 
 #ifdef WITH_DMALLOC
