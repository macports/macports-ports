--- src/protocols/ec_tcp.c.orig	2009-09-08 17:04:47.000000000 +0200
+++ src/protocols/ec_tcp.c	2009-09-08 17:06:15.000000000 +0200
@@ -116,7 +116,7 @@
    tcp = (struct tcp_header *)DECODE_DATA;
    
    opt_start = (u_char *)(tcp + 1);
-   opt_end = (u_char *)((int)tcp + tcp->off * 4);
+   opt_end = (u_char *)((unsigned long)tcp + tcp->off * 4);
 
    DECODED_LEN = (u_int32)(tcp->off * 4);
 
