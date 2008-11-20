--- jpeglib.h.org	Sat Feb 21 14:48:14 1998
+++ jpeglib.h	Tue Feb 25 16:49:36 2003
@@ -13,6 +13,10 @@
 #ifndef JPEGLIB_H
 #define JPEGLIB_H
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /*
  * First we include the configuration files that record how this
  * installation of the JPEG library is set up.  jconfig.h can be
@@ -1091,6 +1095,10 @@
 #ifdef JPEG_INTERNALS
 #include "jpegint.h"		/* fetch private declarations */
 #include "jerror.h"		/* fetch error codes too */
+#endif
+
+#ifdef __cplusplus
+}
 #endif
 
 #endif /* JPEGLIB_H */
