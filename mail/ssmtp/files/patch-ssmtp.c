--- ssmtp.c.old	Sun Feb  1 22:28:40 2004
+++ ssmtp.c	Sun Feb  1 22:28:55 2004
@@ -14,6 +14,7 @@
 */
 #define VERSION "2.60.4"
 
+#include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <sys/param.h>
