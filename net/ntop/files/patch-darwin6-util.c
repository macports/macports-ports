--- util.c	Thu Dec 16 20:13:26 2004
+++ util.c.new	Fri Dec 31 13:31:05 2004
@@ -5183,6 +5183,7 @@
   addr.sin_port   = htons(80);
   memcpy((char *) &addr.sin_addr.s_addr, hptr->h_addr_list[0], hptr->h_length);
 
+#define socklen_t int
   /* Connect the socket to the remote host.  */
   rc = connect(sock, (struct sockaddr*)&addr, (socklen_t) sizeof(addr));
   if (rc != 0) {
