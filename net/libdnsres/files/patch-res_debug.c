--- res_debug.c.org	2005-07-13 17:14:28.000000000 -0700
+++ res_debug.c	2006-02-23 13:49:19.000000000 -0800
@@ -80,6 +80,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <arpa/nameser.h>
+#include <arpa/nameser8_compat.h>
 
 #include <ctype.h>
 #include <stdio.h>
