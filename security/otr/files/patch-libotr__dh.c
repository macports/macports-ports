--- libotr/dh.c.orig	Mon Jan  3 04:59:29 2005
+++ libotr/dh.c	Mon Jan  3 04:59:43 2005
@@ -19,6 +19,7 @@
 
 /* system headers */
 #include <stdlib.h>
+#include <sys/types.h>
 #include <netinet/in.h>
 
 /* libgcrypt headers */
