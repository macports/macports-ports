--- gst/elements/gstfakesrc.h.org	Sun Dec 14 09:30:39 2003
+++ gst/elements/gstfakesrc.h	Sun Dec 14 09:30:45 2003
@@ -30,7 +30,7 @@
 
 G_BEGIN_DECLS
 
-GstElementDetails gst_fakesrc_details;
+extern GstElementDetails gst_fakesrc_details;
 
 typedef enum {
   FAKESRC_FIRST_LAST_LOOP = 1,
