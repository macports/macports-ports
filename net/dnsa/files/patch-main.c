--- main.c.orig	Fri Oct 15 13:52:35 2004
+++ main.c	Fri Oct 15 13:52:47 2004
@@ -6,6 +6,7 @@
 #include <sys/types.h>
 #include <arpa/inet.h>
 #include <sys/socket.h>
+#include <netinet/in.h>
 
 #include "usage.h"
 #include "netdefs.h"
