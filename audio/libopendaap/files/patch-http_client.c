--- http_client.c.orig	Wed Aug  4 21:55:32 2004
+++ http_client.c	Wed Aug  4 21:55:40 2004
@@ -49,6 +49,7 @@
 #include <stdio.h>
 #include <errno.h>
 #include <string.h>
+#include <netinet/in.h>
 
 #include "portability.h"
 
