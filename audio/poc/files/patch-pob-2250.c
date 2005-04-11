--- pob-2250.c.orig	2005-04-03 07:53:19.000000000 -0400
+++ pob-2250.c	2005-04-03 07:53:41.000000000 -0400
@@ -362,7 +362,7 @@
 	  XXX: handle error.
 	**/
       } else {
-      fprintf(stderr, "packet length: %d\n", pkt.length);
+      fprintf(stderr, "packet length: %d\n", (int)pkt.length);
 
 	/*M
 	  Insert new packet into the buffering list.
