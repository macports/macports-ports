--- tools/sesskeys.c.orig	Mon Jan  3 05:05:58 2005
+++ tools/sesskeys.c	Mon Jan  3 05:06:11 2005
@@ -19,6 +19,7 @@
 
 /* system headers */
 #include <stdlib.h>
+#include <sys/types.h>
 #include <netinet/in.h>
 
 /* libgcrypt headers */
