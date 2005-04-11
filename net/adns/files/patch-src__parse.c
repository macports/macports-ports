--- src/parse.c.orig	2005-04-03 06:53:31.000000000 -0400
+++ src/parse.c	2005-04-03 07:53:33.000000000 -0400
@@ -113,7 +113,7 @@
 }
 
 adns_status adns__parse_domain(adns_state ads, int serv, adns_query qu,
-			       vbuf *vb, adns_queryflags flags,
+			       vbuf *vb, parsedomain_flags flags,
 			       const byte *dgram, int dglen, int *cbyte_io,
 			       int max) {
   findlabel_state fls;
