--- fec-pkt.h.orig	2005-04-03 07:36:52.000000000 -0400
+++ fec-pkt.h	2005-04-03 07:37:29.000000000 -0400
@@ -60,6 +60,6 @@
 void fec_pkt_init(/*@out@*/ fec_pkt_t *pkt);
 
 ssize_t fec_pkt_send(fec_pkt_t *pkt, int fd);
-ssize_t fec_pkt_read(fec_pkt_t *pkt, int fd);
+int fec_pkt_read(fec_pkt_t *pkt, int fd);
 
 #endif /* FEC_PKT_H__ */
