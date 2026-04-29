--- res_query.c.org	2005-07-13 17:14:28.000000000 -0700
+++ res_query.c	2006-02-23 13:58:04.000000000 -0800
@@ -92,6 +92,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <arpa/nameser.h>
+#include <arpa/nameser8_compat.h>
 
 #include <stdio.h>
 #include <ctype.h>
