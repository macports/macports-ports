--- libplot/i_rle.c.orig	1999-06-27 10:58:10.000000000 -0600
+++ libplot/i_rle.c	2005-06-13 22:44:03.000000000 -0600
@@ -78,7 +78,7 @@
   else if (rle->outstream)
     {
       rle->outstream->put ((unsigned char)(rle->oblen));
-      rle->outstream->write (&(rle->oblock[0]), rle->oblen);
+      rle->outstream->write ((const char *)&(rle->oblock[0]), rle->oblen);
     }
 #endif  
 
