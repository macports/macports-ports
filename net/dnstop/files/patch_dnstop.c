--- dnstop.c.old	Mon Nov 29 17:24:23 2004
+++ dnstop.c	Mon Nov 29 17:23:16 2004
@@ -25,6 +25,7 @@
 #include <assert.h>
 #include <arpa/inet.h>
 #include <arpa/nameser.h>
+#include <arpa/nameser_compat.h>
 
 #include <sys/socket.h>
 #include <net/if_arp.h>
