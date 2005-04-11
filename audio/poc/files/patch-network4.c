--- network4.c.orig	2004-10-28 05:23:23.000000000 -0400
+++ network4.c	2005-04-03 07:48:28.000000000 -0400
@@ -216,7 +216,7 @@
 /*M
   \emph{Bind a socket to an IPV4 adress and port.}
 **/
-int net_tcp4_bind(int s, unsigned char ip[4], unsigned short port) {
+int net_tcp4_bind(int s, char ip[4], unsigned short port) {
   struct sockaddr_in sa;
 
   memset(&sa, 0, sizeof(sa));
@@ -231,7 +231,7 @@
 }
 
 int net_tcp4_bind_reuse(int s,
-			unsigned char ip[4],
+			char ip[4],
 			unsigned short port) {
   int opt = 1;
   setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
@@ -267,7 +267,7 @@
 			   unsigned char ip[4],
 			   unsigned short *port) {
   struct sockaddr_in sa;
-  int len = sizeof(sa);
+  socklen_t len = sizeof(sa);
   int fd;
 
   fd = accept(s, (struct sockaddr *)&sa, &len);
