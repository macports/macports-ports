--- util.old.c	Wed Nov 17 02:28:57 2004
+++ util.c	Wed Nov 17 03:09:14 2004
@@ -5093,6 +5093,7 @@
   addr.sin_port   = htons(80);
   memcpy((char *) &addr.sin_addr.s_addr, hptr->h_addr_list[0], hptr->h_length);
 
+#define socklen_t int /*stefan lebelt 17.11.2004*/
   /* Connect the socket to the remote host.  */
   rc = connect(sock, (struct sockaddr*)&addr, (socklen_t) sizeof(addr));
   if (rc != 0) {
