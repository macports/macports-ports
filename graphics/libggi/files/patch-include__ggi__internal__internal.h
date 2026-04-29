--- include/ggi/internal/internal.h.orig	2005-04-19 16:49:07.000000000 -0400
+++ include/ggi/internal/internal.h	2005-04-19 16:49:15.000000000 -0400
@@ -30,6 +30,8 @@
 
 #define _INTERNAL_LIBGGI
 
+#include <sys/types.h>
+
 #include <ggi/types.h>
 #include <ggi/internal/gii.h>
 #include <ggi/internal/plat.h>
