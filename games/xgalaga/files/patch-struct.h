--- struct.h.orig	Sun Oct 22 00:36:24 2000
+++ struct.h	Sun Oct 22 00:37:03 2000
@@ -1,3 +1,6 @@
+#ifndef __struct_h__
+#define __struct_h__
+
 #include "Wlib.h"
 
 struct torp {
@@ -38,3 +41,5 @@
     int count;
     W_Image *shape;
 };
+
+#endif /* __struct_h__ */
