--- etc/cnid_dbd/usockfd.c~	2009-03-29 09:23:23.000000000 +0200
+++ etc/cnid_dbd/usockfd.c	2009-11-14 11:11:53.000000000 +0100
@@ -82,7 +82,7 @@
 int tsockfd_create(char *host, u_int16_t ipport, int backlog)
 {
     int sockfd;
-    struct sockaddr_in server;
+    struct sockaddr_in server = { 0 };
     struct hostent     *hp;  
     int                port;
     
