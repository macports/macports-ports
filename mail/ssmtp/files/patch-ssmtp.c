--- ssmtp.c.old	Sun Feb  1 22:28:40 2004
+++ ssmtp.c	Sun Feb  1 22:28:55 2004
@@ -13,6 +13,7 @@
 #define VERSION "2.62"
 #define _GNU_SOURCE
 
+#include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <sys/param.h>
