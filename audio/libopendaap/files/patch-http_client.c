--- http_client.c.orig	Fri Dec 17 00:27:43 2004
+++ http_client.c	Sat Jan  8 05:29:01 2005
@@ -50,6 +50,7 @@
 #include <stdio.h>
 #include <errno.h>
 #include <string.h>
+#include <netinet/in.h>
 
 #include "portability.h"
 #include "thread.h"
