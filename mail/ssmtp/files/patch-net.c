--- net.c.orig	Wed Aug 21 03:55:21 2002
+++ net.c	Wed Aug 21 03:55:37 2002
@@ -5,6 +5,7 @@
  See COPYRIGHT for the license
 
 */
+#include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <stdlib.h>
