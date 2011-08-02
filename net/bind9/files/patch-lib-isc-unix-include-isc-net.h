--- lib/isc/unix/include/isc/net.h.orig	2011-08-02 12:34:03.000000000 +0300
+++ lib/isc/unix/include/isc/net.h	2011-08-02 12:33:09.000000000 +0300
@@ -17,6 +17,7 @@
 
 /* $Id: net.h,v 1.50 2008-12-01 04:14:54 marka Exp $ */
 
+#define __APPLE_USE_RFC_2292
 #ifndef ISC_NET_H
 #define ISC_NET_H 1
 
