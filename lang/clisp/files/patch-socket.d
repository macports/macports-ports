--- src/socket.d.sav	2006-01-06 14:55:36.000000000 -0500
+++ src/socket.d	2006-01-06 14:56:09.000000000 -0500
@@ -481,6 +481,9 @@
  #ifdef HAVE_IPV6
   {
     var struct sockaddr_in6 inaddr;
+#ifdef UNIX_MACOSX
+    memset((void *)&inaddr, 0, sizeof(inaddr));
+#endif
     if (inet_pton(AF_INET6,host,&inaddr.sin6_addr) > 0) {
       inaddr.sin6_family = AF_INET6;
       inaddr.sin6_port = htons(port);
@@ -491,6 +494,9 @@
  #endif
   {
     var struct sockaddr_in inaddr;
+#ifdef UNIX_MACOSX
+    memset((void *)&inaddr, 0, sizeof(inaddr));
+#endif
     if (inet_pton(AF_INET,host,&inaddr.sin_addr) > 0) {
       inaddr.sin_family = AF_INET;
       inaddr.sin_port = htons(port);
@@ -504,6 +510,9 @@
   if (all_digits_dots(host)) {
     var struct sockaddr_in inaddr;
     var uint32 hostinetaddr = inet_addr(host) INET_ADDR_SUFFIX ;
+#ifdef UNIX_MACOSX
+    memset((void *)&inaddr, 0, sizeof(inaddr));
+#endif
     if (!(hostinetaddr == ((uint32) -1))) {
       inaddr.sin_family = AF_INET;
       inaddr.sin_addr.s_addr = hostinetaddr;
@@ -523,6 +532,9 @@
     if (host_ptr->h_addrtype == AF_INET6) {
       /* Set up the socket data. */
       var struct sockaddr_in6 inaddr;
+#ifdef UNIX_MACOSX
+      memset((void *)&inaddr, 0, sizeof(inaddr));
+#endif
       inaddr.sin6_family = AF_INET6;
       inaddr.sin6_addr = *(struct in6_addr *)host_ptr->h_addr;
       inaddr.sin6_port = htons(port);
@@ -533,6 +545,9 @@
     if (host_ptr->h_addrtype == AF_INET) {
       /* Set up the socket data. */
       var struct sockaddr_in inaddr;
+#ifdef UNIX_MACOSX
+      memset((void *)&inaddr, 0, sizeof(inaddr));
+#endif
       inaddr.sin_family = AF_INET;
       inaddr.sin_addr = *(struct in_addr *)host_ptr->h_addr;
       inaddr.sin_port = htons(port);
@@ -658,6 +673,9 @@
     var int oaddrlen;                       /* length of addr */
    #endif
 
+#ifdef UNIX_MACOSX
+    memset((void *)&unaddr, 0, sizeof(unaddr));
+#endif
     unaddr.sun_family = AF_UNIX;
     sprintf (unaddr.sun_path, "%s%d", X_UNIX_PATH, display);
     addr = (struct sockaddr *) &unaddr;
@@ -751,6 +769,9 @@
                                              host_data_t * hd) {
   var sockaddr_max_t addr;
   var SOCKLEN_T addrlen = sizeof(sockaddr_max_t);
+#ifdef UNIX_MACOSX
+  memset((void *)&addr, 0, sizeof(addr));
+#endif
   if (getsockname(socket_handle,(struct sockaddr *)&addr,&addrlen) < 0)
     return NULL;
   /* Fill in hd->hostname and hd->port. */
@@ -801,6 +822,9 @@
   var sockaddr_max_t addr;
   var SOCKLEN_T addrlen = sizeof(sockaddr_max_t);
   var struct hostent* hp = NULL;
+#ifdef UNIX_MACOSX
+  memset((void *)&addr, 0, sizeof(addr));
+#endif
   /* Get host's IP address. */
   if (getpeername(socket_handle,(struct sockaddr *)&addr,&addrlen) < 0)
     return NULL;
@@ -896,6 +920,9 @@
   var SOCKET fd;
   var sockaddr_max_t addr;
   var SOCKLEN_T addrlen = sizeof(sockaddr_max_t);
+#ifdef UNIX_MACOSX
+  memset((void *)&addr, 0, sizeof(addr));
+#endif
   if (getsockname(sock,(struct sockaddr *)&addr,&addrlen) < 0)
     return INVALID_SOCKET;
   switch (((struct sockaddr *)&addr)->sa_family) {
@@ -931,6 +958,9 @@
  #endif
   var sockaddr_max_t addr;
   var SOCKLEN_T addrlen = sizeof(sockaddr_max_t);
+#ifdef UNIX_MACOSX
+  memset((void *)&addr, 0, sizeof(addr));
+#endif
   return accept(socket_handle,(struct sockaddr *)&addr,&addrlen);
   /* We can ignore the contents of addr, because we can retrieve it again
      through socket_getpeername() later. */
