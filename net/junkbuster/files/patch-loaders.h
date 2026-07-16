diff -urN ../ijb-zlib-11.orig/loaders.h ./loaders.h
--- ../ijb-zlib-11.orig/loaders.h	Wed Dec 31 16:00:00 1969
+++ ./loaders.h	Thu Jan  6 15:36:44 2005
@@ -0,0 +1,6 @@
+#ifndef __LOADERS_H_INCLUDE__
+#define __LOADERS_H_INCLUDE__
+
+void * zalloc(int);
+
+#endif /* __LOADERS_H_INCLUDE__ */
