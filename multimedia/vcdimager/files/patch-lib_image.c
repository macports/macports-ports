--- lib/image.c.orig	Mon Nov 10 04:57:49 2003
+++ lib/image.c	Sat Oct 30 21:39:55 2004
@@ -76,7 +76,7 @@
 }
 
 int
-vcd_image_sink_write (VcdImageSink *obj, void *buf, uint32_t lsn)
+vcd_image_sink_write (VcdImageSink *obj, void *buf, lsn_t lsn)
 {
   vcd_assert (obj != NULL);
 
