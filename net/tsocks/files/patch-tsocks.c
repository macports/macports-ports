--- tsocks.c.orig	2007-03-28 12:26:49.000000000 +0100
+++ tsocks.c	2007-03-28 12:25:55.000000000 +0100
@@ -76,7 +76,7 @@
 static char *conffile = NULL;
 
 /* Exported Function Prototypes */
-void _init(void);
+void _init(void) __attribute__ ((constructor));
 int connect(CONNECT_SIGNATURE);
 int select(SELECT_SIGNATURE);
 int poll(POLL_SIGNATURE);
@@ -225,9 +225,10 @@
 	struct sockaddr_in *connaddr;
 	struct sockaddr_in peer_address;
 	struct sockaddr_in server_address;
-   int gotvalidserver = 0, rc, namelen = sizeof(peer_address);
+   int gotvalidserver = 0, rc;
 	int sock_type = -1;
-	int sock_type_len = sizeof(sock_type);
+	socklen_t sock_type_len = sizeof(sock_type);
+	socklen_t namelen = sizeof(peer_address);
 	unsigned int res = -1;
 	struct serverent *path;
    struct connreq *newconn;
@@ -699,7 +700,7 @@
              * come around again (since we can't flag it for read, we don't know
              * if there is any data to be read and can't be bothered checking) */
             if (conn->selectevents & WRITE) {
-               setevents |= POLLOUT; 
+               ufds[i].revents |= (conn->selectevents & WRITE);
                nevents++;
             }
          }
@@ -937,7 +938,12 @@
                     sizeof(conn->serveraddr));
 
    show_msg(MSGDEBUG, "Connect returned %d, errno is %d\n", rc, errno); 
-   if (rc) {
+   if (rc && errno == EISCONN) {
+      rc = 0;
+      show_msg(MSGDEBUG, "Socket %d already connected to SOCKS server\n",
+conn->sockid);
+      conn->state = CONNECTED;
+   } else if (rc) {
       if (errno != EINPROGRESS) {
          show_msg(MSGERR, "Error %d attempting to connect to SOCKS "
                   "server (%s)\n", errno, strerror(errno));
