--- gst/elements/gstmultidisksrc.h.org	Sun Dec 14 08:55:39 2003
+++ gst/elements/gstmultidisksrc.h	Sun Dec 14 08:55:46 2003
@@ -28,7 +28,7 @@
 
 G_BEGIN_DECLS
 
-GstElementDetails gst_multidisksrc_details;
+extern GstElementDetails gst_multidisksrc_details;
 
 #define GST_TYPE_MULTIDISKSRC \
   (gst_multidisksrc_get_type())
