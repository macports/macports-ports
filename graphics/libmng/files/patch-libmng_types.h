--- libmng_types.h.orig	Sun Jan  5 22:53:38 2003
+++ libmng_types.h	Sun Jan  5 22:54:16 2003
@@ -158,7 +158,7 @@
 #if defined(WIN32) || defined(linux)   /* different header locations */
 #include "lcms.h"
 #else
-#include "lcms/lcms.h"
+#include "lcms.h"
 #endif
 #endif /* MNG_INCLUDE_LCMS */
 
