--- gst/elements/gststatistics.h.org	Sun Dec 14 08:13:04 2003
+++ gst/elements/gststatistics.h	Sun Dec 14 08:12:59 2003
@@ -29,7 +29,7 @@
 
 G_BEGIN_DECLS
 
-GstElementDetails gst_statistics_details;
+extern GstElementDetails gst_statistics_details;
 
 
 #define GST_TYPE_STATISTICS \
