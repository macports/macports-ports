--- parser.c.orig	Sat Dec  4 09:48:11 2004
+++ parser.c	Sat Dec  4 09:48:21 2004
@@ -4,6 +4,7 @@
 
 */
 
+#include <sys/types.h>
 #include <netinet/in.h>
 #include <sys/socket.h>
 #include <arpa/inet.h>
