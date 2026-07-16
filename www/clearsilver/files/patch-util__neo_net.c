--- ./util/neo_net.c.orig	2005-12-06 05:17:08.000000000 +0100
+++ ./util/neo_net.c	2012-04-23 18:00:58.297894435 +0200
@@ -45,27 +45,27 @@
   struct sockaddr_in serv_addr;
 
   if ((sfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
-    return nerr_raise_errno(NERR_IO, "Unable to create socket");
+    return nerr_raise_errno(NERR_IO, "%s", "Unable to create socket");
 
   if (setsockopt (sfd, SOL_SOCKET, SO_REUSEADDR, (char *)&on,
 	sizeof(on)) == -1)
   {
     close(sfd);
-    return nerr_raise_errno(NERR_IO, "Unable to setsockopt(SO_REUSEADDR)");
+    return nerr_raise_errno(NERR_IO, "%s", "Unable to setsockopt(SO_REUSEADDR)");
   }
    
   if(setsockopt (sfd, SOL_SOCKET, SO_KEEPALIVE, (void *)&on,
 	sizeof(on)) == -1) 
   {
     close(sfd);
-    return nerr_raise_errno(NERR_IO, "Unable to setsockopt(SO_KEEPALIVE)");
+    return nerr_raise_errno(NERR_IO, "%s", "Unable to setsockopt(SO_KEEPALIVE)");
   }
    
   if(setsockopt (sfd, IPPROTO_TCP, TCP_NODELAY, (void *)&on, 
 	sizeof(on)) == -1)
   {
     close(sfd);
-    return nerr_raise_errno(NERR_IO, "Unable to setsockopt(TCP_NODELAY)");
+    return nerr_raise_errno(NERR_IO, "%s", "Unable to setsockopt(TCP_NODELAY)");
   }
   serv_addr.sin_family = AF_INET;
   serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
@@ -121,7 +121,7 @@
     if (fd >= 0) break;
     if (ShutdownAccept || errno != EINTR)
     {
-      return nerr_raise_errno(NERR_IO, "accept() returned error");
+      return nerr_raise_errno(NERR_IO, "%s", "accept() returned error");
     }
     if (errno == EINTR)
     {
@@ -133,7 +133,7 @@
   if (my_sock == NULL)
   {
     close(fd);
-    return nerr_raise(NERR_NOMEM, "Unable to allocate memory for NSOCK");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory for NSOCK");
   }
   my_sock->fd = fd;
   my_sock->remote_ip = ntohl(client_addr.sin_addr.s_addr);
@@ -176,19 +176,19 @@
   serv_addr.sin_port = htons(port);
   fd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
   if (fd == -1)
-    return nerr_raise_errno(NERR_IO, "Unable to create socket");
+    return nerr_raise_errno(NERR_IO, "%s", "Unable to create socket");
 
   flags = fcntl(fd, F_GETFL, 0 );
   if (flags == -1)
   {
     close(fd);
-    return nerr_raise_errno(NERR_IO, "Unable to get socket flags");
+    return nerr_raise_errno(NERR_IO, "%s", "Unable to get socket flags");
   }
 
   if (fcntl(fd, F_SETFL, flags | O_NDELAY) == -1)
   {
     close(fd);
-    return nerr_raise_errno(NERR_IO, "Unable to set O_NDELAY");
+    return nerr_raise_errno(NERR_IO, "%s", "Unable to set O_NDELAY");
   }
 
   x = 0;
@@ -233,7 +233,7 @@
     if (getsockopt(fd, SOL_SOCKET, SO_ERROR, &optval, &optlen) == -1) 
     {
       close(fd);
-      return nerr_raise_errno(NERR_IO, 
+      return nerr_raise_errno(NERR_IO, "%s", 
 	  "Unable to getsockopt to determine connection error");
     }
 
@@ -253,20 +253,20 @@
   if (flags == -1)
   {
     close(fd);
-    return nerr_raise_errno(NERR_IO, "Unable to get socket flags");
+    return nerr_raise_errno(NERR_IO, "%s", "Unable to get socket flags");
   }
 
   if (fcntl(fd, F_SETFL, flags & ~O_NDELAY) == -1)
   {
     close(fd);
-    return nerr_raise_errno(NERR_IO, "Unable to set O_NDELAY");
+    return nerr_raise_errno(NERR_IO, "%s", "Unable to set O_NDELAY");
   }
 
   my_sock = (NSOCK *) calloc(1, sizeof(NSOCK));
   if (my_sock == NULL)
   {
     close(fd);
-    return nerr_raise(NERR_NOMEM, "Unable to allocate memory for NSOCK");
+    return nerr_raise(NERR_NOMEM, "%s", "Unable to allocate memory for NSOCK");
   }
   my_sock->fd = fd;
   my_sock->remote_ip = ntohl(serv_addr.sin_addr.s_addr);
@@ -344,18 +344,18 @@
   r = select(sock->fd+1, &fds, NULL, NULL, &tv);
   if (r == 0)
   {
-    return nerr_raise(NERR_IO, "read failed: Timeout");
+    return nerr_raise(NERR_IO, "%s", "read failed: Timeout");
   }
   if (r < 0)
   {
-    return nerr_raise_errno(NERR_IO, "select for read failed");
+    return nerr_raise_errno(NERR_IO, "%s", "select for read failed");
   }
 
   sock->ibuf[0] = '\0';
   r = read(sock->fd, sock->ibuf, NET_BUFSIZE);
   if (r < 0)
   {
-    return nerr_raise_errno(NERR_IO, "read failed");
+    return nerr_raise_errno(NERR_IO, "%s", "read failed");
   }
 
   sock->ib = 0;
@@ -390,17 +390,17 @@
     r = select(sock->fd+1, NULL, &fds, NULL, &tv);
     if (r == 0)
     {
-      return nerr_raise(NERR_IO, "write failed: Timeout");
+      return nerr_raise(NERR_IO, "%s", "write failed: Timeout");
     }
     if (r < 0)
     {
-      return nerr_raise_errno(NERR_IO, "select for write failed");
+      return nerr_raise_errno(NERR_IO, "%s", "select for write failed");
     }
 
     r = write(sock->fd, sock->obuf + x, sock->ol - x);
     if (r < 0)
     {
-      return nerr_raise_errno(NERR_IO, "select for write failed");
+      return nerr_raise_errno(NERR_IO, "%s", "select for write failed");
     }
     x += r;
   }
@@ -559,7 +559,7 @@
   if (buf[0] != ',')
   {
     free(data);
-    return nerr_raise(NERR_PARSE, "Format error on stream, expected ','");
+    return nerr_raise(NERR_PARSE, "%s", "Format error on stream, expected ','");
   }
 
   *b = data;
