--- gst/autoplug/gstspideridentity.h.org	Sun Dec 14 07:36:39 2003
+++ gst/autoplug/gstspideridentity.h	Sun Dec 14 07:47:07 2003
@@ -30,7 +30,7 @@
 
 G_BEGIN_DECLS
 
-GstElementDetails gst_spider_identity_details;
+extern GstElementDetails gst_spider_identity_details;
 
 
 #define GST_TYPE_SPIDER_IDENTITY \
