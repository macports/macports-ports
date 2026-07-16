--- getaddrinfo.c.org	2005-07-13 17:14:28.000000000 -0700
+++ getaddrinfo.c	2006-02-23 14:01:33.000000000 -0800
@@ -117,6 +117,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <arpa/nameser.h>
+#include <arpa/nameser_compat.h>
 #include <string.h>
 #include <stdlib.h>
 #include <stddef.h>
