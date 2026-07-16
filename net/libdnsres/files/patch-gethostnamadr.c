--- gethostnamadr.c.org	2005-07-13 17:14:28.000000000 -0700
+++ gethostnamadr.c	2006-02-23 13:59:51.000000000 -0800
@@ -87,6 +87,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <arpa/nameser.h>
+#include <arpa/nameser_compat.h>
 #include <stdio.h>
 #include <ctype.h>
 #include <errno.h>
