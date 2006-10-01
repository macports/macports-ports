--- fec-pkt.c.orig	2004-12-30 17:24:07.000000000 +0100
+++ fec-pkt.c	2006-10-01 18:39:24.000000000 +0200
@@ -66,7 +66,7 @@
   Reads a FEC packet from the filedescriptor, and unpacks the header
   fields into the header structure.
 **/
-int fec_pkt_read(fec_pkt_t *pkt, int fd) {
+ssize_t fec_pkt_read(fec_pkt_t *pkt, int fd) {
   assert(pkt != NULL);
 
   /*M
