--- test/hello-system/system.h.orig	2019-09-13 13:13:26.492859000 -0600
+++ test/hello-system/system.h	2019-09-13 13:13:37.963118000 -0600
@@ -3,6 +3,7 @@
 #include <winsock2.h>
 #include <ws2tcpip.h>
 #else
+#include <sys/socket.h>
 #include <netdb.h>
 #endif
 
