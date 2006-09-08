--- support/Util/dbuf.h.orig	2006-07-24 07:01:13.000000000 +0200
+++ support/Util/dbuf.h	2006-07-24 07:01:13.000000000 +0200
@@ -28,6 +28,8 @@
 #ifndef __DBUF_H
 #define __DBUF_H
 
+#include <stdlib.h>
+
 struct dbuf_s {
   size_t alloc;   /* size of allocated buffer in bytes */
   size_t len;     /* actual size of the buffer in bytes */
