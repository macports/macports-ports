--- ssmtp.c.orig	Sun Jan  5 10:16:11 2003
+++ ssmtp.c	Sun Jan  5 10:16:26 2003
@@ -13,7 +13,7 @@
 
 */
 #define VERSION "2.60.1"
-
+#include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <sys/param.h>
