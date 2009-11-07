--- libusb/os/darwin_usb.c.orig	2009-09-02 17:18:57.000000000 -0700
+++ libusb/os/darwin_usb.c	2009-09-02 17:19:24.000000000 -0700
@@ -281,7 +281,7 @@
   if (kresult != kIOReturnSuccess) {
     _usbi_log (ctx, LOG_LEVEL_ERROR, "could not add hotplug event source: %s", darwin_error_str (kresult));
 
-    pthread_exit ((void *)kresult);
+    pthread_exit ((void *)(intptr_t)kresult);
   }
 
   /* arm notifiers */
