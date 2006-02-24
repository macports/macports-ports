--- res_init.c.org	2006-02-23 13:53:26.000000000 -0800
+++ res_init.c	2006-02-23 13:54:07.000000000 -0800
@@ -92,6 +92,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <arpa/nameser.h>
+#include <arpa/nameser8_compat.h>
 
 #include <stdio.h>
 #include <ctype.h>
