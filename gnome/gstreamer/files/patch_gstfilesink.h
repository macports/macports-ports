--- gst/elements/gstfilesink.h.org	Sun Dec 14 09:52:09 2003
+++ gst/elements/gstfilesink.h	Sun Dec 14 09:52:23 2003
@@ -30,7 +30,7 @@
 
 G_BEGIN_DECLS
 
-GstElementDetails gst_filesink_details;
+extern GstElementDetails gst_filesink_details;
 
 
 #define GST_TYPE_FILESINK \
