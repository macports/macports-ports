--- libusb/os/darwin_usb.c.orig	2009-07-21 14:39:55.000000000 -0700
+++ libusb/os/darwin_usb.c	2009-07-21 14:42:39.000000000 -0700
@@ -150,7 +150,8 @@
   io_cf_plugin_ref_t *plugInInterface = NULL;
   usb_device_t **device;
   io_service_t usbDevice;
-  long result, score;
+  long result;
+  SInt32 score;
 
   if (!IOIteratorIsValid (deviceIterator) || !(usbDevice = IOIteratorNext(deviceIterator)))
     return NULL;
@@ -278,7 +279,7 @@
   if (kresult != kIOReturnSuccess) {
     _usbi_log (ctx, LOG_LEVEL_ERROR, "could not add hotplug event source: %s", darwin_error_str (kresult));
 
-    pthread_exit ((void *)kresult);
+    pthread_exit ((void *)(intptr_t)kresult);
   }
 
   /* arm notifiers */
@@ -767,7 +768,7 @@
   io_service_t          usbInterface = IO_OBJECT_NULL;
   IOReturn kresult;
   IOCFPlugInInterface **plugInInterface = NULL;
-  long                  score;
+  SInt32                score;
   uint8_t               new_config;
 
   /* current interface */
