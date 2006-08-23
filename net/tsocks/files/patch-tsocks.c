--- tsocks.c.orig	2006-01-28 16:36:44.000000000 -0800
+++ tsocks.c	2006-01-28 16:27:51.000000000 -0800
@@ -99,6 +99,7 @@
 static int read_socksv4_req(struct connreq *conn);
 static int read_socksv5_connect(struct connreq *conn);
 static int read_socksv5_auth(struct connreq *conn);
+void _init(void) __attribute__ ((constructor));
 
 void _init(void) {
 #ifdef USE_OLD_DLSYM
@@ -191,9 +192,10 @@
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
@@ -660,7 +660,7 @@
              * come around again (since we can't flag it for read, we don't know
              * if there is any data to be read and can't be bothered checking) */
             if (conn->selectevents & WRITE) {
-               setevents |= POLLOUT; 
+               ufds[i].revents |= (conn->selectevents & WRITE);
                nevents++;
             }
          }
@@ -854,7 +854,11 @@
                     sizeof(conn->serveraddr));

    show_msg(MSGDEBUG, "Connect returned %d, errno is %d\n", rc, errno); 
-	if (rc) {
+	if (rc && errno == EISCONN) {
+      rc = 0;
+      show_msg(MSGDEBUG, "Socket %d already connected to SOCKS server\n", conn->sockid);
+      conn->state = CONNECTED;
+   } else if (rc) {
       if (errno != EINPROGRESS) {
          show_msg(MSGERR, "Error %d attempting to connect to SOCKS "
                   "server (%s)\n", errno, strerror(errno));
