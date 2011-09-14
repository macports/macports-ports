--- qcppdialogimpl.h.orig	2009-06-23 15:35:06.000000000 -0500
+++ qcppdialogimpl.h	2011-09-14 03:18:04.000000000 -0500
@@ -105,4 +105,21 @@
 
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
