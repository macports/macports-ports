--- js/src/jsstddef.h.orig	2009-04-20 20:27:12.000000000 +0200
+++ js/src/jsstddef.h	2009-07-24 22:56:46.000000000 +0200
@@ -79,5 +79,8 @@
 #endif
 
 #include <stddef.h>
+#ifdef HAVE_CONFIG_H
+#include <config.h>
+#endif
 
 
