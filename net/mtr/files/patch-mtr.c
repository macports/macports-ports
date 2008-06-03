--- mtr.c.old	2008-06-04 00:52:05.000000000 +0200
+++ mtr.c	2008-06-04 00:52:45.000000000 +0200
@@ -384,7 +384,7 @@
   bzero( &hints, sizeof hints );
   hints.ai_family = af;
   hints.ai_socktype = SOCK_DGRAM;
-  error = getaddrinfo( Hostname, "0", &hints, &res );
+  error = getaddrinfo( Hostname, "", &hints, &res );
   if ( error ) {
     perror( gai_strerror(error) );
     exit( EXIT_FAILURE );