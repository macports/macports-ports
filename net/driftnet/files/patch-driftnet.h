--- driftnet.h.orig	Mon Jul 14 10:17:42 2003
+++ driftnet.h	Mon Jul 14 10:17:54 2003
@@ -39,7 +39,7 @@
 typedef struct _connection {
     struct in_addr src, dst;
     short int sport, dport;
-    uint32_t isn;
+    u_int32_t isn;
     unsigned int len, off, alloc;
     unsigned char *data, *gif, *jpeg, *mpeg;
     int fin;
