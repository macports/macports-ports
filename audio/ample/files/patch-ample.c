--- src/ample.c.orig	Sat Mar 27 15:01:42 2004
+++ src/ample.c	Sat Mar 27 15:01:48 2004
@@ -92,7 +92,7 @@
 	
 	setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
 	address.sin_family = AF_INET;
-	address.sin_port = htons((uint16_t)gconf.port);
+	address.sin_port = htons((u_int16_t)gconf.port);
 	memset(&(address.sin_addr), 0, sizeof(address.sin_addr));
 	
 	if(bind(sock, (struct sockaddr *)&address, sizeof(struct sockaddr_in)))
