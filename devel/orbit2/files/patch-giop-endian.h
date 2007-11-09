--- ./include/orbit/GIOP/giop-endian.h.orig	2007-09-10 14:11:47.000000000 +0200
+++ ./include/orbit/GIOP/giop-endian.h	2007-11-08 01:13:09.000000000 +0100
@@ -7,10 +7,13 @@ G_BEGIN_DECLS
 
 #ifdef ORBIT2_INTERNAL_API
 
+/* G_INLINE_FUNC declared as static inline, so can't declare as extern here */
+#ifndef __APPLE__
 /* This is also defined in IIOP-types.c */
 void giop_byteswap(guchar *outdata,
 		   const guchar *data,
 		   gulong datalen);
+#endif
 
 #if defined(G_CAN_INLINE) && !defined(GIOP_DO_NOT_INLINE_IIOP_BYTESWAP)
 G_INLINE_FUNC void giop_byteswap(guchar *outdata,
