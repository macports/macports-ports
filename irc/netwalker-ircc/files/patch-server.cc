--- server.cc.orig	Mon Mar 29 05:07:40 2004
+++ server.cc	Mon Mar 29 05:07:49 2004
@@ -17,6 +17,7 @@
 #include <netinet/in.h>
 #include <netdb.h>
 #include <arpa/inet.h>
+#include <sys/time.h>
 #include "server.h"
 #include "functions.h"
 #include "user.h"
