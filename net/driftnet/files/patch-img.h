--- img.h.orig	2002-07-09 14:26:41.000000000 -0500
+++ img.h	2012-05-18 01:03:25.000000000 -0500
@@ -26,7 +26,7 @@
 typedef uint32_t pel;
 
 /* Yuk. GDKRGB expects data in a specific ordering. */
-#if defined(DRIFTNET_LITTLE_ENDIAN)
+#if __LITTLE_ENDIAN__
 #   define PEL(r, g, b)        ((pel)((chan)(r) | ((chan)(g) << 8) | ((chan)(b) << 16)))
 #   define PELA(r, g, b, a)    ((pel)((chan)(r) | ((chan)(g) << 8) | ((chan)(b) << 16) | ((chan)(a) << 24)))
 
@@ -34,7 +34,7 @@
 #   define GETG(p)             ((chan)(((p) & (pel)0x0000ff00) >>  8))
 #   define GETB(p)             ((chan)(((p) & (pel)0x00ff0000) >> 16))
 #   define GETA(p)             ((chan)(((p) & (pel)0xff000000) >> 24))
-#elif defined(DRIFTNET_BIG_ENDIAN)
+#elif __BIG_ENDIAN__
 #   define PEL(r, g, b)        ((pel)(((chan)(r) << 24) | ((chan)(g) << 16) | ((chan)(b) << 8)))
 #   define PELA(r, g, b, a)    ((pel)(((chan)(r) << 24) | ((chan)(g) << 16) | ((chan)(b) << 8) | ((chan)(a))))
 
