--- dnstop.c.org	Sun Aug 31 07:26:12 2003
+++ dnstop.c	Sun Aug 31 07:30:44 2003
@@ -24,7 +24,8 @@
 #include <curses.h>
 #include <assert.h>
 #include <arpa/inet.h>
-#include <arpa/nameser.h>
+#include <arpa/nameser.h> 
+#include <arpa/nameser_compat.h>
 
 #include <sys/socket.h>
 #include <net/if_arp.h>
