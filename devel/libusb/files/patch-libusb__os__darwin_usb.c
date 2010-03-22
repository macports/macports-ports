--- libusb/os/darwin_usb.c.orig	2009-11-21 09:10:21.000000000 -0800
+++ libusb/os/darwin_usb.c	2010-03-22 10:29:38.000000000 -0700
@@ -279,7 +279,7 @@
   if (kresult != kIOReturnSuccess) {
     _usbi_log (ctx, LOG_LEVEL_ERROR, "could not add hotplug event source: %s", darwin_error_str (kresult));
 
-    pthread_exit ((void *)kresult);
+    pthread_exit ((void *)(intptr_t)kresult);
   }
 
   /* arm notifiers */
@@ -1191,9 +1191,9 @@
   tpriv->req.bmRequestType     = setup->bmRequestType;
   tpriv->req.bRequest          = setup->bRequest;
   /* these values should already be in bus order */
-  tpriv->req.wValue            = setup->wValue;
-  tpriv->req.wIndex            = setup->wIndex;
-  tpriv->req.wLength           = setup->wLength;
+  tpriv->req.wValue            = libusb_le16_to_cpu(setup->wValue);
+  tpriv->req.wIndex            = libusb_le16_to_cpu(setup->wIndex);
+  tpriv->req.wLength           = libusb_le16_to_cpu(setup->wLength);
   /* data is stored after the libusb control block */
   tpriv->req.pData             = transfer->buffer + LIBUSB_CONTROL_SETUP_SIZE;
   tpriv->req.completionTimeout = transfer->timeout;
