--- res_comp.c.org	2005-07-13 17:14:28.000000000 -0700
+++ res_comp.c	2006-02-23 13:48:16.000000000 -0800
@@ -60,6 +60,7 @@
 #include <sys/time.h>
 #include <netinet/in.h>
 #include <arpa/nameser.h>
+#include <arpa/nameser8_compat.h>
 
 #include <stdio.h>
 #include <ctype.h>
