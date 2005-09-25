--- libplot/z_write.c.orig 2005-09-23 14:16:40.000000000 +0200
+++ libplot/z_write.c  2005-09-23 13:59:26.000000000 +0200
@@ -484,7 +484,7 @@
   ostream *stream;
 
   stream = (ostream *)png_get_io_ptr (png_ptr);
-  stream->write (data, length);
+  stream->write ((const char *)data, length);
 }
 
 static void 

