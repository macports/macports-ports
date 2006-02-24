--- res_send.c.org	2005-07-13 17:14:28.000000000 -0700
+++ res_send.c	2006-02-23 13:58:58.000000000 -0800
@@ -99,6 +99,7 @@
 #include <sys/uio.h>
 #include <netinet/in.h>
 #include <arpa/nameser.h>
+#include <arpa/nameser8_compat.h>
 #include <arpa/inet.h>
 
 #include <stdio.h>
