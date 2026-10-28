--- dnsspoof.c.orig	Fri Oct 15 13:51:17 2004
+++ dnsspoof.c	Fri Oct 15 13:51:24 2004
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
 
 #include "dnsspoof.h"
