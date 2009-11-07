--- libusb/io.c.orig	2009-09-02 17:20:20.000000000 -0700
+++ libusb/io.c	2009-09-02 17:21:01.000000000 -0700
@@ -1485,6 +1485,7 @@
 	return (r == ETIMEDOUT);
 }
 
+#ifndef USBI_OS_HANDLES_TIMEOUT
 static void handle_timeout(struct usbi_transfer *itransfer)
 {
 	struct libusb_transfer *transfer =
@@ -1497,6 +1498,7 @@
 		usbi_warn(TRANSFER_CTX(transfer),
 			"async cancel failed %d errno=%d", r, errno);
 }
+#endif
 
 static int handle_timeouts(struct libusb_context *ctx)
 {
