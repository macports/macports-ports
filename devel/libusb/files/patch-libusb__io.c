--- libusb/io.c.orig	2009-09-02 17:20:20.000000000 -0700
+++ libusb/io.c	2009-09-02 17:21:01.000000000 -0700
@@ -1663,6 +1663,7 @@
 	return (r == ETIMEDOUT);
 }
 
+#ifndef USBI_OS_HANDLES_TIMEOUT
 static void handle_timeout(struct usbi_transfer *itransfer)
 {
 	struct libusb_transfer *transfer =
@@ -1675,6 +1676,7 @@
 		usbi_warn(TRANSFER_CTX(transfer),
 			"async cancel failed %d errno=%d", r, errno);
 }
+#endif
 
 #ifdef USBI_OS_HANDLES_TIMEOUT
 static int handle_timeouts_locked(struct libusb_context *ctx)
