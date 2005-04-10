--- darwin.c.orig	2005-01-08 12:55:04.000000000 -0500
+++ darwin.c	2005-04-01 19:41:04.000000000 -0500
@@ -330,7 +330,7 @@
 static int claim_interface ( usb_dev_handle *dev, int interface )
 {
   io_iterator_t interface_iterator;
-  io_service_t  usbInterface;
+  io_service_t  usbInterface = NULL;
   io_return_t result;
   io_cf_plugin_ref_t *plugInInterface = NULL;
 
@@ -483,6 +483,7 @@
 {
   struct darwin_dev_handle *device;
   io_return_t result;
+  int interface;
 
   if ( usb_debug > 3 )
     fprintf ( stderr, "usb_set_configuration: called for config %x\n", configuration );
@@ -495,6 +496,8 @@
 
   /* Setting configuration will invalidate the interface, so we need
      to reclaim it. First, dispose of existing interface, if any. */
+  interface = dev->interface;
+
   if ( device->interface )
     usb_release_interface(dev, dev->interface);
 
@@ -505,8 +508,8 @@
 		  darwin_error_str(result));
 
   /* Reclaim interface: assume zero */
-  if (dev->interface != -1)
-    result = claim_interface(dev, dev->interface);
+  if (interface != -1)
+    result = claim_interface(dev, interface);
 
   dev->config = configuration;
 
