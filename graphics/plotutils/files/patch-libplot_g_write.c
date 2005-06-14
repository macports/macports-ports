--- libplot/g_write.c.orig	2000-05-19 10:10:01.000000000 -0600
+++ libplot/g_write.c	2005-06-13 20:53:43.000000000 -0600
@@ -40,7 +40,7 @@
     }
 #ifdef LIBPLOTTER
   else if (data->outstream)
-    data->outstream->write(c, n);
+    data->outstream->write((const char *)c, n);
 #endif
 }
 
