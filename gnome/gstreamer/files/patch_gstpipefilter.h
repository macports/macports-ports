--- gst/elements/gstpipefilter.h.org	Sun Dec 14 08:43:39 2003
+++ gst/elements/gstpipefilter.h	Sun Dec 14 08:43:46 2003
@@ -31,7 +31,7 @@
 
 G_BEGIN_DECLS
 
-GstElementDetails gst_pipefilter_details;
+extern GstElementDetails gst_pipefilter_details;
 
 #define GST_TYPE_PIPEFILTER \
   (gst_pipefilter_get_type())
