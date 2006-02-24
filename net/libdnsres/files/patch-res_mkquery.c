--- res_mkquery.c.org	2005-07-13 17:14:28.000000000 -0700
+++ res_mkquery.c	2006-02-23 13:50:51.000000000 -0800
@@ -87,6 +87,7 @@
 #include <sys/socket.h>
 #include <netinet/in.h>
 #include <arpa/nameser.h>
+#include <arpa/nameser8_compat.h>
 
 #include <stdio.h>
 #include <string.h>
