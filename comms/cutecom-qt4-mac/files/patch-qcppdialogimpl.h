--- qcppdialogimpl.h.orig	2008-03-12 16:09:50.000000000 -0500
+++ qcppdialogimpl.h	2009-03-28 09:05:42.000000000 -0500
@@ -103,4 +103,21 @@
 
 };
 
+#if defined(__FreeBSD__)
+
+#define	DEVLIST	"/dev/cuaU0"<<"/dev/cuaU1"<<"/dev/cuad0"<<"/dev/cuad1";
+#define DEFAULT_DEV "/dev/cuaU0"
+
+#elif defined(__APPLE__)
+
+#define	DEVLIST	"/dev/cu.usbserial"<<"/dev/cu.KeySerial1";
+#define DEFAULT_DEV "/dev/cu.usbserial"
+
+#else	// Default to Linux devices.
+
+#define	DEVLIST	"/dev/ttyS0"<<"/dev/ttyS1"<<"/dev/ttyS2"<<"/dev/ttyS3";
+#define DEFAULT_DEV "/dev/ttyS0"
+
+#endif
+
 #endif
