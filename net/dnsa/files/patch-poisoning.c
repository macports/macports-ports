--- poisoning.c.orig	Fri Oct 15 13:50:02 2004
+++ poisoning.c	Fri Oct 15 13:50:10 2004
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
 
 #include "poisoning.h"
