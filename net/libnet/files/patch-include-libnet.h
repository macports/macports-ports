--- include/libnet.h.orig       Sat Aug 16 23:04:16 2003
+++ include/libnet.h    Sat Aug 16 23:04:46 2003
@@ -84,9 +84,7 @@
 #define LIBNET_VERSION  "1.0.2a"
 
 #if (!LIBNET_LIL_ENDIAN && !LIBNET_BIG_ENDIAN)
-#error "byte order has not been specified, you'll
-need to #define either LIBNET_LIL_ENDIAN or LIBNET_BIG_ENDIAN.  See the
-documentation regarding the libnet-config script."
+#error "byte order has not been specified, you'll need to #define either LIBNET_LIL_ENDIAN or LIBNET_BIG_ENDIAN.  See the documentation regarding the libnet-config script."
 #endif
 
 #endif  /* __LIBNET_H */
