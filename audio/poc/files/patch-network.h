--- network.h.orig	2004-10-28 05:23:23.000000000 -0400
+++ network.h	2005-04-03 07:48:06.000000000 -0400
@@ -14,10 +14,10 @@
 int net_tcp4_nonblock_socket(void);
 int net_tcp4_socket_nonblock(int s);
 int net_tcp4_bind(int s,
-		  unsigned char ip[4],
+		  char ip[4],
 		  unsigned short port);
 int net_tcp4_bind_reuse(int s,
-			unsigned char ip[4],
+			char ip[4],
 			unsigned short port);
 int net_tcp4_listen_socket(char *hostname, unsigned short port);
 int net_tcp4_accept_socket(int s, unsigned char ip[4], unsigned short *port);
