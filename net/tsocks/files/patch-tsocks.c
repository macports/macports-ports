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

