--- src/network/network.cc.orig	2017-07-22 21:14:53 UTC
+++ src/network/network.cc
@@ -335,7 +335,7 @@ bool Connection::try_bind( const char *a
       }
     }
 
-    if ( bind( sock(), &local_addr.sa, local_addr_len ) == 0 ) {
+    if ( ::bind( sock(), &local_addr.sa, local_addr_len ) == 0 ) {
       set_MTU( local_addr.sa.sa_family );
       return true;
     } else if ( i == search_high ) { /* last port to search */
