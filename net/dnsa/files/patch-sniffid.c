--- sniffid.c.orig	Fri Oct 15 13:47:13 2004
+++ sniffid.c	Fri Oct 15 13:47:27 2004
@@ -5,10 +5,9 @@
 #include <string.h>
 #include <netinet/in.h>		
 #include <arpa/inet.h>	
+#include <sys/socket.h>
 #include <netinet/if_ether.h>
-#include <netinet/ether.h>
 #include <net/ethernet.h>
-#include <sys/socket.h>
 #include <libnet.h>
 #include <sys/stat.h>
 #include <sys/types.h>
